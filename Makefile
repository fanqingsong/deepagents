# DeepAgents LangGraph 应用 Makefile

.PHONY: help build up down logs test clean status restart interactive

# 默认目标
help:
	@echo "DeepAgents LangGraph 应用管理命令："
	@echo ""
	@echo "  make build       - 构建 Docker 镜像"
	@echo "  make up          - 启动所有服务"
	@echo "  make down        - 停止所有服务"
	@echo "  make restart     - 重启所有服务"
	@echo "  make logs        - 查看服务日志"
	@echo "  make status      - 查看服务状态"
	@echo "  make interactive - 进入交互模式"
	@echo "  make test        - 运行测试"
	@echo "  make clean       - 清理所有资源"
	@echo "  make help        - 显示此帮助信息"

# 构建镜像
build:
	@echo "🔨 构建 Docker 镜像..."
	docker compose build

# 启动服务
up:
	@echo "🚀 启动 DeepAgents LangGraph 应用..."
	docker compose up -d
	@echo "⏳ 等待服务启动..."
	@sleep 5
	@echo "✅ 服务启动完成！"
	@echo ""
	@echo "🎯 使用方法："
	@echo "  make interactive - 访问应用界面"
	@echo "  make logs       - 查看日志"
	@echo ""
	@echo "🌐 监控服务："
	@echo "  Grafana: http://localhost:3000 (admin/admin123)"
	@echo "  Prometheus: http://localhost:9090"

# 停止服务
down:
	@echo "🛑 停止 DeepAgents LangGraph 应用..."
	docker compose down

# 重启服务
restart: down up

# 查看日志
logs:
	@echo "📋 查看服务日志..."
	docker compose logs -f

# 查看服务状态
status:
	@echo "📊 服务状态："
	docker compose ps

# 访问应用
interactive:
	@echo "🎯 访问 DeepAgents 应用..."
	@echo "应用地址: http://localhost:8000"
	@echo "LangGraph Studio: http://localhost:8000/studio"

# 运行测试
test:
	@echo "🧪 运行测试..."
	docker compose exec deepagents-app python test_azure_openai.py

# 清理所有资源
clean:
	@echo "🧹 清理所有资源..."
	docker compose down -v --remove-orphans
	docker system prune -f
	@echo "✅ 清理完成！"

# 快速启动（包含环境检查）
quick-start:
	@echo "🚀 快速启动 DeepAgents LangGraph 应用..."
	@if [ ! -f research/.env ]; then \
		echo "⚠️  环境配置文件不存在，从示例文件创建..."; \
		cp research/env.example research/.env; \
		echo "📝 请编辑 research/.env 文件配置必要的环境变量"; \
	fi
	@make build
	@make up
	@echo "🎉 快速启动完成！"
	@echo "💡 使用 'make interactive' 访问应用界面"

# 生产模式（带日志输出）
prod:
	@echo "🔧 生产模式启动..."
	docker compose up --build

# LangGraph 开发模式（本地）
dev-langgraph:
	@echo "🔧 LangGraph 开发模式启动（本地）..."
	@echo "📁 切换到研究目录..."
	@cd research && \
	echo "📦 安装依赖..." && \
	pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple && \
	echo "🚀 启动 LangGraph 开发服务器..." && \
	langgraph dev --host 0.0.0.0 --port 8000

# LangGraph 开发模式（Docker）
dev:
	@echo "🔧 LangGraph 开发模式启动（Docker）..."
	@echo "📦 使用 Docker 容器运行开发环境..."
	docker compose -f docker-compose.dev.yml up --build

# 前端开发模式
dev-frontend:
	@echo "🎨 前端开发模式启动..."
	@echo "📁 切换到前端目录..."
	@cd frontend && \
	echo "📦 安装依赖..." && \
	npm install --registry https://registry.npmmirror.com && \
	echo "🚀 启动前端开发服务器..." && \
	npm run dev

# 开发模式（带热重载）
dev-watch:
	@echo "🔧 开发模式启动（带热重载）..."
	@echo "📁 切换到研究目录..."
	@cd research && \
	echo "📦 安装依赖..." && \
	pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple && \
	echo "🚀 启动 LangGraph 开发服务器（热重载）..." && \
	langgraph dev --host 0.0.0.0 --port 8000 --watch

# 仅启动核心服务
core:
	@echo "⚡ 启动核心服务..."
	docker compose up -d deepagents-app postgres redis

# 启动监控服务
monitor:
	@echo "📊 启动监控服务..."
	docker compose up -d prometheus grafana

# 帮助信息
help:
	@echo "DeepAgents LangGraph 微服务管理工具"
	@echo ""
	@echo "🚀 生产环境："
	@echo "  make build        - 构建 Docker 镜像"
	@echo "  make up           - 启动所有服务"
	@echo "  make down         - 停止所有服务"
	@echo "  make restart      - 重启所有服务"
	@echo "  make logs         - 查看服务日志"
	@echo "  make clean        - 清理所有资源"
	@echo "  make interactive  - 访问应用界面"
	@echo "  make test         - 运行测试"
	@echo "  make quick-start  - 快速启动"
	@echo ""
	@echo "🔧 开发环境："
	@echo "  make dev          - 开发模式（Docker）"
	@echo "  make dev-langgraph - LangGraph 开发模式（本地）"
	@echo "  make dev-frontend - 前端开发模式（本地）"
	@echo "  make dev-watch    - 开发模式（带热重载）"
	@echo ""
	@echo "⚡ 其他："
	@echo "  make core         - 仅启动核心服务"
	@echo "  make monitor      - 启动监控服务"
