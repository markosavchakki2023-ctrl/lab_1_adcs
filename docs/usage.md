# Інструкція користувача `build-engineer`

## 1. Вимоги до середовища

Потрібні:

- VS Code із розширенням GitHub Copilot;
- вхід у GitHub-акаунт із доступом GitHub Copilot для студентів;
- встановлений Git;
- Python 3 із доступною командою `python`.

## 2. Запуск агента

1. Відкрийте репозиторій у VS Code.
2. Відкрийте Copilot Chat.
3. Виберіть агента `build-engineer`.
4. Для повного сценарію виконайте:

   ```text
   /init
   ```

`init` послідовно запускає `git-init`, `create-project`, `create-build`, `create-actions`, `check`. Якщо крок завершується помилкою, наступні кроки не запускаються.

Окремі commands:

| Command | Що робить і коли запускати |
|---|---|
| `/git-init` | Перевіряє Git-репозиторій, створює або доповнює `.gitignore` і показує `git status`; запускайте для підготовки Git |
| `/create-project` | Викликає `project-scaffold` і створює початкові `src/`, `tests/`, `src/hello.py`, `README.md`, `.gitignore`; запускайте першим кроком створення проєкту |
| `/create-build` | Викликає `build-and-test`, створює конфігурацію pytest, функцію `add(a, b)`, тести та `ci.sh`/`ci.bat`; запускайте після `/create-project` |
| `/create-actions` | Викликає `github-actions` і створює `.github/workflows/ci.yml`; запускайте після `/create-build` |
| `/check` | Лише читає та перевіряє структуру, складання, тести, workflow, Git і `docs/ai-log.md`; запускайте після створення або для повторної перевірки |

## 3. Очікуваний результат після `/init`

Після успішного завершення мають з’явитися:

```text
src/hello.py
tests/test_basic.py
requirements.txt
pytest.ini
ci.sh
ci.bat
.github/workflows/ci.yml
```

Також `/init` створює або доповнює `README.md`, `.gitignore`, каталоги `src/` і `tests/`. CI-скрипти можуть створити `.venv/` і `build/`; вони виключаються з Git через `.gitignore`.

Успіх оголошується лише після проходження всіх п’яти кроків і `check` без `FAIL`.

## 4. Локальна перевірка без агента

### Windows PowerShell

У корені репозиторію виконайте:

```powershell
.\ci.bat
```

### Linux/macOS

У корені репозиторію виконайте:

```bash
chmod +x ci.sh
./ci.sh
```

Скрипти:

1. створюють `.venv`, якщо його ще немає;
2. встановлюють залежності з `requirements.txt`;
3. запускають `pytest`;
4. створюють каталог `build/`;
5. генерують запускні файли `build/hello` і `build/hello.bat`.

Скрипт зупиняється при помилці та повертає ненульовий код завершення.

## 5. Запуск зібраного проєкту

### Windows

```powershell
build\hello.bat
```

### Linux/macOS

```bash
./build/hello
```

Очікуваний вивід:

```text
Hello, World!
```

## 6. Окремий запуск тестів

Після виконання CI активуйте `.venv`.

### Windows PowerShell

```powershell
.\.venv\Scripts\Activate.ps1
pytest -v
```

### Linux/macOS

```bash
source .venv/bin/activate
pytest -v
```

Параметр `-v` показує назву тесту `TestBasicAddition`, а успішний результат має містити повідомлення на кшталт:

```text
tests/test_basic.py::TestBasicAddition::test_add PASSED
1 passed
```

## 7. Повторний запуск

Команду `/init` можна запускати повторно. Кожна команда перевіряє наявні файли, не перезаписує їх без потреби та не дублює рядки конфігурації. Наявні файли не руйнуються.

## 8. Типові проблеми

### Python не знайдено

Перевірте:

```text
python --version
```

У Windows додатково можна перевірити `py --version`, а в Linux/macOS — `python3 --version`. Якщо придатний Python недоступний, встановіть Python 3, додайте його до PATH і повторіть команду.

### Немає прав на `ci.sh`

На Linux/macOS виконайте:

```bash
chmod +x ci.sh
./ci.sh
```

Якщо помилка залишається, перевірте права доступу до репозиторію та покажіть фактичний текст помилки.

### Copilot не бачить агента

Перевірте, що репозиторій відкрито у VS Code, розширення GitHub Copilot встановлено й активне, а в Copilot Chat виконано вхід у GitHub-акаунт із відповідним студентським доступом. Переконайтеся, що файл `.github/agents/build-engineer.agent.md` існує, після чого перезавантажте вікно VS Code і знову відкрийте список агентів.
