Савчак Марко Михайлович, КІ-407, варіант 20. Створення спеціалізованого AI-агента з навичками (skills), командами (commands) та оркестрацією для генерації, складання, тестування і перевірки кросплатформного проєкту Hello World.

# AI-агент `build-engineer`

AI-агент `build-engineer` для GitHub Copilot у VS Code створює Python-проєкт Hello World із `venv` і `pytest`, системою складання, тестами та CI для Windows, Linux і macOS.

## Запуск агента

1. Відкрийте репозиторій у VS Code.
2. Відкрийте Copilot Chat.
3. Виберіть агента `build-engineer`.
4. Запустіть повний сценарій командою `/init-project`.

Окремі команди: `/git-init`, `/create-project`, `/create-build`, `/create-actions`, `/check`.

## Запуск зібраного проєкту та тестів

Після виконання CI запустіть `build\hello.bat` у Windows або `./build/hello` у Linux/macOS. Очікуваний вивід — `Hello, World!`. Для окремого запуску тестів активуйте `.venv` і виконайте `pytest -v`. Детальна інструкція: [docs/usage.md](docs/usage.md).

## Структура репозиторію

- `.github/agents/` — manifest агента `build-engineer`;
- `.github/prompts/` — команди `git-init`, `create-project`, `create-build`, `create-actions`, `check` та orchestrator `init-project`;
- `.github/skills/` — skills `project-scaffold`, `build-and-test`, `github-actions`;
- `src/`, `tests/`, `requirements.txt`, `pytest.ini`, `ci.sh`, `ci.bat` — файли Python-проєкту, складання і тестування;
- `.github/workflows/ci.yml` — GitHub Actions workflow.

Детальна схема взаємодії: [docs/architecture.md](docs/architecture.md).

## Гілки

- `develop` містить агента;
- `feature/...` містить повний проєкт;
- результат згенерований запуском агента.