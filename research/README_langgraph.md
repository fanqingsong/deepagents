# DeepAgents LangGraph 微服务

基于 LangGraph 和 Docker Compose 的 DeepAgents 微服务，使用 `langgraph up` 命令启动。

这是 DeepAgents 项目的研究示例，展示了如何将 DeepAgents 部署为微服务。

## 架构概述

```
┌─────────────────────────────────────────────────────────────────┐
│                    DeepAgents LangGraph 应用架构                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Client      │    │  DeepAgents API │    │   PostgreSQL    │
│  (API/Studio)   │────│ (langgraph up)  │────│    (数据库)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                │              ┌─────────────────┐
                                │              │     Redis       │
                                │              │    (缓存)       │
                                │              └─────────────────┘
                                │
┌─────────────────┐    ┌─────────────────┐
│    Grafana      │    │   Prometheus    │
│   (监控面板)     │────│   (指标收集)    │
└─────────────────┘    └─────────────────┘
```

## 服务组件说明

### 1. 应用层
- **DeepAgents API**: 基于 LangGraph 的微服务
  - 使用 `langgraph up` 命令启动
  - 提供 RESTful API 接口
  - 支持 LangGraph Studio 界面
  - 研究代理服务

### 2. 数据层
- **PostgreSQL**: 主数据库
  - 存储 Agent 配置和对话历史
  - 任务和文件状态管理
- **Redis**: 缓存和会话存储
  - 提高响应性能
  - 会话管理

### 3. 监控层
- **Prometheus**: 指标收集
  - 服务健康监控
  - 性能指标收集
- **Grafana**: 可视化面板
  - 实时监控仪表板
  - 性能分析图表

## 快速开始

### 1. 环境准备

```bash
# 复制环境配置文件
cp env.example .env

# 编辑环境变量
vim .env
# 特别是 Azure OpenAI 配置：
# AZURE_OPENAI_API_KEY=your_azure_openai_api_key
# AZURE_OPENAI_ENDPOINT=https://your-resource-name.openai.azure.com/
# AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4
```

### 国内源配置

本项目已配置国内源以加速部署：

- **Python 包**: 清华大学 PyPI 镜像 (`https://pypi.tuna.tsinghua.edu.cn/simple`)
- **系统包**: 中科大 APT 镜像 (`mirrors.ustc.edu.cn`)
- **Docker 镜像**: 阿里云镜像仓库 (`registry.cn-hangzhou.aliyuncs.com`)

### 2. 启动服务

```bash
# 启动所有服务
./start.sh

# 或者使用 Makefile
make quick-start
```

### 3. 访问应用

```bash
# 访问应用界面
make interactive

# 或者直接访问
# http://localhost:8000 - API 接口
# http://localhost:8000/studio - LangGraph Studio
```

## 功能特性

### 智能 Agent 路由

应用会根据用户输入自动路由到合适的 Agent：

- **research**: 研究、搜索、分析相关任务
- **coding**: 编程、代码相关任务  
- **general**: 通用对话和任务

### LangGraph Studio 界面

提供可视化的图编辑和调试界面：

- **图可视化**: 实时查看 Agent 执行流程
- **调试工具**: 逐步调试和监控
- **状态管理**: 查看和修改状态
- **API 测试**: 直接在界面中测试 API

### RESTful API 接口

支持标准的 HTTP API 调用：

```bash
# 调用 Agent
curl -X POST "http://localhost:8000/runs/stream" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {"messages": [{"role": "user", "content": "你好"}]},
    "config": {"configurable": {"thread_id": "test"}}
  }'
```

### 异步支持

支持异步模式运行：

```bash
# 设置环境变量
export DEEPAGENTS_MODE=async

# 启动应用
make up
make interactive
```

## 管理命令

### 基本操作

```bash
make build       # 构建 Docker 镜像
make up          # 启动所有服务
make down        # 停止所有服务
make restart     # 重启所有服务
make logs        # 查看服务日志
make status      # 查看服务状态
```

### 访问和测试

```bash
make interactive # 访问应用界面
make test        # 运行测试
make clean       # 清理所有资源
```

### 开发模式

```bash
make dev         # 开发模式（带日志输出）
make core        # 仅启动核心服务
make monitor     # 启动监控服务
```

## 配置说明

### 环境变量

| 变量名 | 说明 | 示例值 |
|--------|------|--------|
| `AZURE_OPENAI_API_KEY` | Azure OpenAI API 密钥 | `abc123...` |
| `AZURE_OPENAI_ENDPOINT` | Azure OpenAI 终结点 | `https://myresource.openai.azure.com/` |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | 部署名称 | `gpt-4` |
| `DEEPAGENTS_MODE` | 运行模式 | `interactive` 或 `async` |

### Agent 配置

应用预配置了三个专业 Agent：

1. **Research Agent**: 擅长研究和分析
2. **Coding Agent**: 专精编程和代码
3. **General Agent**: 通用对话助手

## 监控和日志

### 健康检查

```bash
# 查看服务状态
make status

# 查看日志
make logs
```

### 监控面板

- **Grafana**: http://localhost:3000 (admin/admin123)
- **Prometheus**: http://localhost:9090

## 故障排除

### 常见问题

1. **Agent 初始化失败**
   - 检查 Azure OpenAI 配置
   - 查看容器日志：`make logs`

2. **交互模式无响应**
   - 确认服务正在运行：`make status`
   - 检查环境变量配置

3. **数据库连接失败**
   - 检查 PostgreSQL 服务状态
   - 验证连接参数

### 调试步骤

1. 检查环境变量配置
2. 查看容器日志
3. 验证 Azure OpenAI 连接
4. 检查网络连接

## 开发指南

### 添加新的 Agent

1. 在 `langgraph_app.py` 中创建新的 Agent 函数
2. 在 `initialize_agents()` 中注册新 Agent
3. 更新路由逻辑

### 自定义工具

1. 定义工具函数
2. 在 Agent 创建时传入工具
3. 更新工具描述

### 扩展功能

1. 修改 `create_main_graph()` 添加新节点
2. 更新状态管理
3. 添加新的中间件

## 许可证

MIT License
