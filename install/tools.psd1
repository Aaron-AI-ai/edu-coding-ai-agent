# 교육 환경 도구 목록 - check / download / install 이 모두 이 파일 하나를 읽는다
# Level  : 필수 = 실습 프로젝트가 돌기 위해 꼭 필요 · 권장 = 특정 실습(위키 · 그래프 · 영상 · 화면 검증)에 필요
# Kind   : cli = 명령으로 버전 확인 · app = 설치 경로 / winget 목록으로 확인
# Min    : 최소 버전 (비우면 설치만 확인) · Major = 이 주 버전만 허용 (Java 21)
# Silent : winget 이 안 될 때 install\packages 의 설치 파일을 직접 실행하는 무인 옵션 (.msi 는 /qn 자동)
# Script : winget 도 설치 파일도 없을 때 쓰는 공식 설치 스크립트 (PowerShell)
@{
    Tools = @(
        @{
            Id = 'git'; Name = 'Git for Windows'; Level = '필수'; Kind = 'cli'
            Cmd = 'git'; Args = @('--version'); Regex = '(\d+\.\d+\.\d+)'; Min = '2.40.0'
            Winget = 'Git.Git'; Silent = '/VERYSILENT /NORESTART /NOCANCEL /SP-'
            Why = 'Claude Code 가 Windows 에서 Git Bash 를 쓴다 · 저장소 clone · worktree'
        }
        @{
            Id = 'node'; Name = 'Node.js LTS (npm · npx)'; Level = '필수'; Kind = 'cli'
            Cmd = 'node'; Args = @('--version'); Regex = 'v(\d+\.\d+\.\d+)'; Min = '22.0.0'
            Winget = 'OpenJS.NodeJS.LTS'
            Why = 'edu-stock-chart-ui (Vite) · npx skills · Playwright MCP · HyperFrames (22+)'
        }
        @{
            Id = 'java'; Name = 'JDK 21 (Azul Zulu)'; Level = '필수'; Kind = 'cli'
            Cmd = 'java'; Args = @('-version'); Regex = 'version "(\d+(?:\.\d+)*)'; Min = '21'; Major = 21
            Winget = 'Azul.Zulu.21.JDK'
            Why = 'edu-stock-chart (Spring Boot 3.4 · Gradle 8.6 · toolchain 21)'
        }
        @{
            Id = 'claude'; Name = 'Claude Code'; Level = '필수'; Kind = 'cli'
            Cmd = 'claude'; Args = @('--version'); Regex = '(\d+\.\d+\.\d+)'; Min = '2.1.223'
            Winget = 'Anthropic.ClaudeCode'; Script = 'irm https://claude.ai/install.ps1 | iex'
            Why = '과정 전체 · /code-review 는 2.1.223 이상'
        }
        @{
            Id = 'python'; Name = 'Python 3.12'; Level = '권장'; Kind = 'cli'
            Cmd = 'python'; Args = @('--version'); Regex = 'Python (\d+\.\d+\.\d+)'; Min = '3.10.0'
            Winget = 'Python.Python.3.12'; Silent = '/quiet InstallAllUsers=0 PrependPath=1 Include_test=0'
            Why = 'graphify (3.10+)'
        }
        @{
            Id = 'uv'; Name = 'uv (Python 도구 관리)'; Level = '권장'; Kind = 'cli'
            Cmd = 'uv'; Args = @('--version'); Regex = 'uv (\d+\.\d+\.\d+)'
            Winget = 'astral-sh.uv'; Script = 'irm https://astral.sh/uv/install.ps1 | iex'
            Why = 'graphify 설치 (uv tool install --python-preference only-managed --python 3.12 graphifyy) · obsidian-second-brain'
        }
        @{
            Id = 'ffmpeg'; Name = 'FFmpeg'; Level = '권장'; Kind = 'cli'
            Cmd = 'ffmpeg'; Args = @('-version'); Regex = 'ffmpeg version (\S+)'
            Winget = 'Gyan.FFmpeg'
            Why = 'HyperFrames 영상 렌더'
        }
        @{
            Id = 'chrome'; Name = 'Google Chrome'; Level = '권장'; Kind = 'app'
            Paths = @('%ProgramFiles%\Google\Chrome\Application\chrome.exe', '%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe', '%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe')
            Winget = 'Google.Chrome'; Silent = '/silent /install'
            Why = 'Playwright MCP 화면 검증 · Hallmark 화면 검사'
        }
        @{
            Id = 'obsidian'; Name = 'Obsidian'; Level = '권장'; Kind = 'app'
            Paths = @('%LOCALAPPDATA%\Programs\Obsidian\Obsidian.exe', '%ProgramFiles%\Obsidian\Obsidian.exe')
            Winget = 'Obsidian.Obsidian'; Silent = '/S'
            Why = 'LLM 위키 실습 (obsidian-second-brain)'
        }
        @{
            Id = 'orca'; Name = 'Orca (에이전트 병렬 실행)'; Level = '권장'; Kind = 'app'
            Paths = @('%LOCALAPPDATA%\Programs\Orca\Orca.exe', '%LOCALAPPDATA%\Programs\orca\Orca.exe', '%ProgramFiles%\Orca\Orca.exe')
            Winget = 'StablyAI.Orca'; Silent = '/S'
            GitHub = 'stablyai/orca'; Asset = '(?i)\.exe$'
            Why = 'Claude Code · Codex 를 워크트리별 탭으로 동시에 실행'
        }
    )

    # 실습 서비스가 쓰는 포트 - 다른 프로그램이 쓰고 있으면 충돌
    Ports = @(8080, 5173)

    # 설치 · 실습 중 접속하는 주소
    Hosts = @('github.com', 'registry.npmjs.org', 'claude.ai', 'api.anthropic.com', 'services.gradle.org', 'repo.maven.apache.org')
}
