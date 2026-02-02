# 我的博客 - Hugo + PaperMod主题

基于Hugo静态网站生成器和PaperMod主题构建的个人技术博客。

## 🚀 快速开始

### 环境要求
- Hugo (扩展版) v0.155.1+
- Git
- 支持Markdown的编辑器

### 安装Hugo
```bash
# macOS (使用Homebrew)
brew install hugo

# 验证安装
hugo version
```

### 启动开发服务器
```bash
# 使用部署脚本
./deploy.sh dev

# 或直接使用Hugo
hugo server -D
```

访问 http://localhost:1313/ 查看网站。

## 📁 项目结构

```
.
├── archetypes/          # 内容模板
├── assets/             # 资源文件
├── content/            # 网站内容
│   ├── posts/         # 博客文章
│   ├── about.md       # 关于页面
│   ├── archives.md    # 归档页面
│   ├── categories.md  # 分类页面
│   ├── tags.md        # 标签页面
│   ├── search.md      # 搜索页面
│   └── 404.md         # 404页面
├── data/              # 数据文件
├── i18n/              # 国际化文件
│   └── zh-cn.yaml    # 中文翻译
├── layouts/           # 布局文件（覆盖主题）
├── static/            # 静态文件
├── themes/            # 主题目录
│   └── PaperMod/     # PaperMod主题
├── hugo.toml          # 主配置文件
├── deploy.sh          # 部署脚本
└── README.md          # 本文件
```

## ✍️ 写作指南

### 创建新文章
```bash
# 使用Hugo命令
hugo new posts/文章标题.md

# 或手动创建
# 在content/posts/目录下创建Markdown文件
```

### 文章Front Matter示例
```yaml
---
title: "文章标题"
date: 2024-01-15T10:00:00+08:00
draft: false
tags: ["标签1", "标签2"]
categories: ["分类1"]
summary: "文章摘要"
description: "文章描述（SEO用）"
author: "作者名"
showToc: true
TocOpen: false
ShowReadingTime: true
ShowShareButtons: true
cover:
    image: "/images/cover.jpg"
    alt: "封面描述"
    caption: "封面标题"
---
```

### 常用Shortcodes
```markdown
{{</* highlight go "linenos=table" */>}}
// 代码示例
package main
{{</* /highlight */>}}

{{</* notice "info" */>}}
**提示信息**
{{</* /notice */>}}

{{</* img src="/images/photo.jpg" alt="描述" width="800" */>}}
```

## ⚙️ 配置说明

### 主要配置文件：hugo.toml

#### 网站基本信息
```toml
baseURL = "http://localhost:1313/"
title = "我的博客"
theme = "PaperMod"
languageCode = "zh-cn"
```

#### 功能开关
```toml
[params]
  ShowReadingTime = true      # 显示阅读时间
  ShowShareButtons = true     # 显示分享按钮
  ShowPostNavLinks = true     # 显示上下篇导航
  ShowBreadCrumbs = true      # 显示面包屑
  ShowCodeCopyButtons = true  # 显示代码复制按钮
  toc = true                  # 启用目录
  highlight = true            # 启用代码高亮
```

#### 首页配置
```toml
[params.homeInfoParams]
  Title = "欢迎来到我的博客"
  Content = "博客描述内容"
  AlignSocialIconsTo = "left"
```

#### 社交媒体
```toml
[params]
  socialIcons = [
    { name = "github", url = "https://github.com/yourusername" },
    { name = "twitter", url = "https://twitter.com/yourusername" },
    { name = "rss", url = "index.xml" }
  ]
```

## 🚀 部署

### 使用部署脚本
```bash
# 构建网站（开发环境）
./deploy.sh dev build

# 构建网站（生产环境）
./deploy.sh prod build

# 构建并部署到GitHub Pages
# 首先在脚本中设置GITHUB_REPO变量
./deploy.sh prod deploy

# 清理构建目录
./deploy.sh clean
```

### 手动部署到GitHub Pages
1. 在GitHub上创建仓库
2. 修改hugo.toml中的baseURL
3. 构建网站：`hugo --minify`
4. 部署到gh-pages分支

## 🎨 主题定制

### 自定义CSS
1. 创建 `assets/css/custom.css`
2. 在hugo.toml中启用：
```toml
[params]
  customCSS = ["css/custom.css"]
```

### 覆盖主题文件
不要直接修改themes/PaperMod/中的文件，而是：
1. 复制主题文件到layouts目录
2. 修改layouts中的副本

例如覆盖header：
```bash
cp themes/PaperMod/layouts/partials/header.html layouts/partials/
```

## 🔧 常用命令

```bash
# 启动开发服务器
hugo server -D

# 构建网站（生产环境）
hugo --minify

# 创建新文章
hugo new posts/文章标题.md

# 查看帮助
hugo help

# 清理缓存
rm -rf public/ resources/_gen/
```

## 📊 网站统计

### 启用Google Analytics
在hugo.toml中添加：
```toml
[services.googleAnalytics]
  id = "UA-XXXXXXXXX-X"
```

### 启用评论系统（Utterances）
在hugo.toml中添加：
```toml
[params]
  comments = true
  utterances = {
    repo = "yourusername/your-repo",
    issueTerm = "pathname",
    label = "comments"
  }
```

## 🐛 故障排除

### 常见问题
1. **Hugo服务器启动失败**
   - 检查hugo.toml语法
   - 确保主题已安装：`git submodule update --init --recursive`

2. **页面显示异常**
   - 清理缓存：`rm -rf public/ resources/_gen/`
   - 重启Hugo服务器

3. **构建速度慢**
   - 禁用不需要的功能：`disableKinds = ["RSS", "taxonomy", "term"]`
   - 使用`--ignoreCache`参数

### 调试模式
```bash
# 启用详细日志
hugo server -D -v

# 检查配置
hugo config
```

## 📚 学习资源

- [Hugo官方文档](https://gohugo.io/documentation/)
- [PaperMod主题文档](https://github.com/adityatelange/hugo-PaperMod)
- [Hugo中文社区](https://hugo-china.org/)
- [Markdown语法指南](https://www.markdownguide.org/)

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

MIT License

---

*最后更新: {{ now.Format "2006年1月2日" }}*

*Happy Blogging!* 🎉