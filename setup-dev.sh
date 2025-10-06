#!/bin/bash

# DeepAgents 开发环境安装脚本

echo "🔧 DeepAgents 开发环境安装脚本"
echo "=================================="

# 检查 Python 版本
echo "🐍 检查 Python 版本..."
python_version=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
required_version="3.11"

if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" = "$required_version" ]; then
    echo "✅ Python 版本满足要求: $python_version"
else
    echo "❌ Python 版本不满足要求: 需要 >= $required_version, 当前: $python_version"
    exit 1
fi

# 创建虚拟环境
echo "📦 创建虚拟环境..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "✅ 虚拟环境创建完成"
else
    echo "✅ 虚拟环境已存在"
fi

# 激活虚拟环境
echo "🔌 激活虚拟环境..."
source venv/bin/activate

# 升级 pip
echo "⬆️  升级 pip..."
pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple

# 安装依赖
echo "📚 安装项目依赖..."
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 安装开发依赖
echo "🛠️  安装开发依赖..."
pip install langgraph-cli[inmem] -i https://pypi.tuna.tsinghua.edu.cn/simple

# 检查安装
echo "🔍 检查安装..."
if command -v langgraph &> /dev/null; then
    echo "✅ langgraph-cli 安装成功"
    langgraph --version
else
    echo "❌ langgraph-cli 安装失败"
    exit 1
fi

echo ""
echo "🎉 开发环境安装完成！"
echo ""
echo "🚀 使用方法："
echo "  1. 激活虚拟环境: source venv/bin/activate"
echo "  2. 启动开发服务器: langgraph dev --host 0.0.0.0 --port 8000"
echo "  3. 或使用 Makefile: make dev-langgraph"
echo ""
echo "🌐 访问地址："
echo "  - LangGraph Studio: http://localhost:8000/studio"
echo "  - API 接口: http://localhost:8000"
