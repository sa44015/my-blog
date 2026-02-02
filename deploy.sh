#!/bin/bash

# Hugo博客部署脚本
# 使用方法: ./deploy.sh [环境]
# 可选环境: dev, prod (默认: prod)

set -e  # 遇到错误时退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查Hugo是否安装
check_hugo() {
    if ! command -v hugo &> /dev/null; then
        log_error "Hugo未安装，请先安装Hugo"
        log_info "安装方法: brew install hugo (macOS) 或参考 https://gohugo.io/installation/"
        exit 1
    fi
    
    HUGO_VERSION=$(hugo version)
    log_info "Hugo版本: ${HUGO_VERSION}"
}

# 清理构建目录
clean_build() {
    log_info "清理构建目录..."
    rm -rf public/
    log_success "构建目录已清理"
}

# 构建网站
build_site() {
    local env=$1
    
    log_info "开始构建网站 (环境: ${env})..."
    
    if [ "$env" = "prod" ]; then
        hugo --minify --environment production
    else
        hugo --environment development
    fi
    
    # 检查构建结果
    if [ -d "public" ] && [ "$(ls -A public)" ]; then
        log_success "网站构建完成"
        
        # 统计构建结果
        local page_count=$(find public -name "*.html" | wc -l | tr -d ' ')
        local total_size=$(du -sh public | cut -f1)
        
        log_info "生成页面: ${page_count} 个"
        log_info "总大小: ${total_size}"
    else
        log_error "构建失败，public目录为空"
        exit 1
    fi
}

# 启动开发服务器
develop() {
    log_info "启动开发服务器..."
    log_info "访问地址: http://localhost:1313/"
    log_info "按 Ctrl+C 停止服务器"
    echo ""
    
    hugo server -D --disableFastRender --navigateToChanged
}

# 部署到GitHub Pages
deploy_github() {
    local repo_url=$1
    
    if [ -z "$repo_url" ]; then
        log_warning "未设置GitHub仓库地址，跳过部署"
        log_info "请在脚本中设置GITHUB_REPO变量"
        return
    fi
    
    log_info "部署到GitHub Pages..."
    
    cd public
    
    # 初始化Git仓库
    git init
    git add .
    git commit -m "Deploy $(date '+%Y-%m-%d %H:%M:%S')"
    
    # 推送到GitHub
    git push -f "${repo_url}" main:gh-pages
    
    cd ..
    
    log_success "部署完成"
}

# 生成站点地图
generate_sitemap() {
    log_info "生成站点地图..."
    
    if [ -f "public/sitemap.xml" ]; then
        local sitemap_size=$(wc -l < public/sitemap.xml)
        log_success "站点地图已生成 (${sitemap_size} 行)"
    else
        log_warning "未找到站点地图"
    fi
}

# 检查SEO优化
check_seo() {
    log_info "检查SEO优化..."
    
    # 检查是否有标题
    local pages_without_title=$(grep -r -L "<title>" public/*.html 2>/dev/null | wc -l)
    if [ "$pages_without_title" -gt 0 ]; then
        log_warning "发现 ${pages_without_title} 个页面缺少标题"
    fi
    
    # 检查是否有描述
    local pages_without_desc=$(grep -r -L "meta name=\"description\"" public/*.html 2>/dev/null | wc -l)
    if [ "$pages_without_desc" -gt 0 ]; then
        log_warning "发现 ${pages_without_desc} 个页面缺少描述"
    fi
    
    log_success "SEO检查完成"
}

# 主函数
main() {
    local env=${1:-"prod"}
    local action=${2:-"build"}
    
    log_info "=== Hugo博客部署工具 ==="
    log_info "工作目录: $(pwd)"
    
    # 检查Hugo
    check_hugo
    
    case "$action" in
        "dev")
            develop
            ;;
        "build")
            clean_build
            build_site "$env"
            generate_sitemap
            check_seo
            ;;
        "deploy")
            clean_build
            build_site "$env"
            generate_sitemap
            
            # 设置您的GitHub仓库地址
            # 格式: git@github.com:username/repository.git
            GITHUB_REPO=""
            deploy_github "$GITHUB_REPO"
            ;;
        "clean")
            clean_build
            ;;
        *)
            log_error "未知操作: $action"
            echo ""
            echo "使用方法: $0 [环境] [操作]"
            echo "环境: dev, prod (默认: prod)"
            echo "操作:"
            echo "  dev     启动开发服务器"
            echo "  build   构建网站 (默认)"
            echo "  deploy  构建并部署到GitHub Pages"
            echo "  clean   清理构建目录"
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"