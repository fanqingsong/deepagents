-- DeepAgents 数据库初始化脚本

-- 创建数据库（如果不存在）
-- CREATE DATABASE IF NOT EXISTS deepagents;

-- 使用数据库
-- \c deepagents;

-- 创建 agents 表
CREATE TABLE IF NOT EXISTS agents (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    config JSONB NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建 conversations 表
CREATE TABLE IF NOT EXISTS conversations (
    id SERIAL PRIMARY KEY,
    agent_name VARCHAR(255) NOT NULL,
    session_id VARCHAR(255) NOT NULL,
    messages JSONB NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agent_name) REFERENCES agents(name) ON DELETE CASCADE
);

-- 创建 tasks 表
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    agent_name VARCHAR(255) NOT NULL,
    session_id VARCHAR(255) NOT NULL,
    task_id VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agent_name) REFERENCES agents(name) ON DELETE CASCADE
);

-- 创建 files 表
CREATE TABLE IF NOT EXISTS files (
    id SERIAL PRIMARY KEY,
    agent_name VARCHAR(255) NOT NULL,
    session_id VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    content TEXT,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agent_name) REFERENCES agents(name) ON DELETE CASCADE
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_agents_name ON agents(name);
CREATE INDEX IF NOT EXISTS idx_conversations_agent_session ON conversations(agent_name, session_id);
CREATE INDEX IF NOT EXISTS idx_tasks_agent_session ON tasks(agent_name, session_id);
CREATE INDEX IF NOT EXISTS idx_files_agent_session ON files(agent_name, session_id);

-- 创建更新时间触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为相关表添加更新时间触发器
CREATE TRIGGER update_agents_updated_at BEFORE UPDATE ON agents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_conversations_updated_at BEFORE UPDATE ON conversations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_files_updated_at BEFORE UPDATE ON files
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 插入示例数据
INSERT INTO agents (name, config) VALUES 
('research-agent', '{"instructions": "You are a research assistant", "tools": ["internet_search"], "model": "claude-3-sonnet"}'),
('code-agent', '{"instructions": "You are a coding assistant", "tools": ["file_operations", "code_analysis"], "model": "gpt-4"}')
ON CONFLICT (name) DO NOTHING;
