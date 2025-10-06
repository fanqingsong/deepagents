#!/bin/bash

# DeepAgents LangGraph 应用启动脚本

set -e

echo "🚀 启动 DeepAgents LangGraph 应用..."

# 检查 Docker 和 Docker Compose 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

# 检查环境配置文件
if [ ! -f ".env" ]; then
    echo "⚠️  环境配置文件 .env 不存在，从示例文件创建..."
    cp env.example .env
    echo "📝 请编辑 .env 文件配置必要的环境变量"
    echo "   特别是 Azure OpenAI 配置："
    echo "   AZURE_OPENAI_API_KEY, AZURE_OPENAI_ENDPOINT, AZURE_OPENAI_DEPLOYMENT_NAME"
    read -p "按 Enter 继续..."
fi

# 创建必要的目录
mkdir -p data
mkdir -p grafana/provisioning

# 构建和启动服务
echo "🔨 构建 Docker 镜像..."
docker compose build

echo "🚀 启动服务..."
docker compose up -d

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 5

# 检查服务状态
echo "📊 检查服务状态..."
docker compose ps

echo "✅ DeepAgents LangGraph 应用启动完成！"
echo ""
echo "🎯 使用方法："
echo "   1. 访问应用: http://localhost:8000"
echo "   2. 查看日志: docker compose logs -f deepagents-app"
echo "   3. 停止服务: docker compose down"
echo ""
echo "🌐 服务地址："
echo "   DeepAgents API: http://localhost:8000"
echo "   DeepAgents 前端: http://localhost:3000"
echo "   Grafana 监控: http://localhost:3001 (admin/admin123)"
echo "   Prometheus: http://localhost:9090"
echo ""
echo "💡 提示："
echo "   - 使用 langgraph up 命令启动"
echo "   - 支持 LangGraph Studio 界面"
echo "   - 自动路由到合适的 Agent (research/coding/general)"
