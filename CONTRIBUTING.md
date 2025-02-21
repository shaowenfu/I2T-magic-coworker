# Contributing Guidelines

[English](#contributing-guidelines) | [简体中文](#贡献指南)

## How to Contribute

Thank you for your interest in contributing to I2T Magic! This document provides guidelines and steps for contributing to our project.

### Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the best possible outcome for the project

### Getting Started

1. **Fork the Repository**
   ```bash
   git clone https://github.com/yourusername/i2t_magic.git
   cd i2t_magic
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Set Up Development Environment**
   ```bash
   # Backend
   cd Backend
   pip install -r requirements.txt
   cp .env.example .env
   
   # Frontend
   cd Frontend
   flutter pub get
   ```

### Development Workflow

1. **Code Style**
   - Backend (Python):
     - Follow PEP 8 guidelines
     - Use type hints
     - Write docstrings for functions and classes
   
   - Frontend (Flutter):
     - Follow Dart style guidelines
     - Use camelCase for variables and functions
     - Use PascalCase for classes

2. **Commit Messages**
   ```
   type(scope): description
   
   [optional body]
   [optional footer]
   ```
   Types: feat, fix, docs, style, refactor, test, chore

3. **Testing**
   - Write unit tests for new features
   - Ensure all tests pass before submitting PR
   - Update documentation if needed

### Pull Request Process

1. **Before Submitting**
   - Update your fork to the latest main branch
   - Run tests locally
   - Check code formatting
   - Update documentation if needed

2. **PR Description**
   - Clearly describe the changes
   - Link related issues
   - Include screenshots for UI changes
   - List any breaking changes

3. **Review Process**
   - Maintainers will review your PR
   - Address review comments
   - Keep PR scope focused

### Reporting Issues

- Use issue templates
- Include reproduction steps
- Provide system information
- Add screenshots if applicable

---

# 贡献指南

## 如何贡献

感谢您对 I2T Magic 项目的关注！本文档提供了参与项目贡献的指南和步骤。

### 行为准则

- 保持尊重和包容
- 提供建设性的反馈
- 关注项目的最佳可能成果

### 开始入门

1. **Fork 仓库**
   ```bash
   git clone https://github.com/你的用户名/i2t_magic.git
   cd i2t_magic
   ```

2. **创建分支**
   ```bash
   git checkout -b feature/你的功能名称
   ```

3. **设置开发环境**
   ```bash
   # 后端
   cd Backend
   pip install -r requirements.txt
   cp .env.example .env
   
   # 前端
   cd Frontend
   flutter pub get
   ```

### 开发工作流

1. **代码风格**
   - 后端 (Python):
     - 遵循 PEP 8 规范
     - 使用类型提示
     - 为函数和类编写文档字符串
   
   - 前端 (Flutter):
     - 遵循 Dart 风格指南
     - 变量和函数使用驼峰命名
     - 类使用帕斯卡命名

2. **提交信息**
   ```
   类型(范围): 描述
   
   [可选的正文]
   [可选的脚注]
   ```
   类型：feat, fix, docs, style, refactor, test, chore

3. **测试**
   - 为新功能编写单元测试
   - 提交 PR 前确保所有测试通过
   - 必要时更新文档

### Pull Request 流程

1. **提交前检查**
   - 将分支更新到最新的主分支
   - 本地运行测试
   - 检查代码格式
   - 必要时更新文档

2. **PR 描述**
   - 清晰描述更改内容
   - 关联相关 issues
   - UI 更改需包含截图
   - 列出任何破坏性更改

3. **审查流程**
   - 维护者将审查您的 PR
   - 处理审查意见
   - 保持 PR 范围集中

### 报告问题

- 使用问题模板
- 包含复现步骤
- 提供系统信息
- 必要时添加截图

---

<div align="center">
Made with ❤️ by the I2T Magic Team
</div> 