# Архітектура AI-агента `build-engineer`

## 1. Призначення

Агент автоматизує створення мінімального кросплатформного Python Hello World-проєкту з `venv` і `pytest`, системою складання, юніт-тестами та GitHub Actions CI для Ubuntu, Windows і macOS.

Архітектура вирішує такі проблеми:

- повторюване створення структури проєкту;
- локальне складання, ізольоване середовищем `.venv`;
- запуск тесту `BasicAddition` через `pytest`;
- генерація запускних файлів у `build/`;
- перевірка workflow з matrix для трьох ОС;
- ідемпотентний повторний запуск без руйнування або дублювання конфігурації.

## 2. Склад агента

| Елемент | Файл | Роль |
|---|---|---|
| Manifest | `.github/agents/build-engineer.agent.md` | Визначає роль, область відповідальності, доступні tools, правила, заборонені дії, порядок роботи та критерії успішного завершення |
| Skill | `.github/skills/project-scaffold/SKILL.md` | Створює початкову структуру Python Hello World, `src/hello.py`, `README.md`, `src/`, `tests/` і `.gitignore` |
| Skill | `.github/skills/build-and-test/SKILL.md` | Додає `pytest`, функцію `add(a, b)`, тест `TestBasicAddition`, `ci.sh`, `ci.bat` і генерацію `build/` |
| Skill | `.github/skills/github-actions/SKILL.md` | Створює та перевіряє `.github/workflows/ci.yml` з matrix для трьох ОС |
| Command | `.github/prompts/git-init.prompt.md` | Перевіряє Git, ідемпотентно створює або доповнює `.gitignore`, показує `git status` |
| Command | `.github/prompts/create-project.prompt.md` | Викликає skill `project-scaffold` і створює початковий проєкт |
| Command | `.github/prompts/create-build.prompt.md` | Викликає skill `build-and-test`, запускає CI-скрипт і перевіряє тести та build |
| Command | `.github/prompts/create-actions.prompt.md` | Викликає skill `github-actions` і створює CI workflow |
| Command | `.github/prompts/check.prompt.md` | Read-only перевіряє структуру, skills, commands, складання, тести, workflow, Git і журнал |
| Command | `.github/prompts/init.prompt.md` | Оркестратор: координує решту п’яти commands у визначеному порядку та формує підсумковий звіт |

## 3. Схема взаємодії

```text
init
 |
 +--> git-init
 |
 +--> create-project ----> project-scaffold
 |
 +--> create-build ------> build-and-test
 |
 +--> create-actions ----> github-actions
 |
 +--> check
```

`init` запускає commands послідовно:

```text
git-init -> create-project -> create-build -> create-actions -> check
```

Команди `create-project`, `create-build` і `create-actions` передають виконання відповідним skills. `git-init` і `check` виконують власні перевірки та дії, описані у своїх prompt-файлах.

## 4. Skills

| Skill | Призначення | Вхід | Вихід | Перевірка |
|---|---|---|---|---|
| `project-scaffold` | Початкова структура мінімального Python Hello World-проєкту | Мова `python`, назва проєкту | `src/hello.py`, `README.md`, каталоги `src/` і `tests/`, `.gitignore` | `python src/hello.py` завершується успішно та виводить `Hello, World!`; перевіряються каталоги й записи `.gitignore` |
| `build-and-test` | Локальне складання та юніт-тестування з `venv` і `pytest` | Назва проєкту, `python`, наявний `src/hello.py`, каталоги `src/` і `tests/` | `requirements.txt`, `pytest.ini`, функція `add(a, b)`, `tests/test_basic.py`, `ci.sh`, `ci.bat`, `build/hello`, на Windows також `build/hello.bat` | CI-скрипт, `pytest`, `TestBasicAddition`, запуск build-файлу та виключення build/cache/venv з Git |
| `github-actions` | Кросплатформний GitHub Actions workflow | Наявні `ci.sh`, `ci.bat`, назва проєкту | `.github/workflows/ci.yml` | YAML, matrix `ubuntu-latest`/`windows-latest`/`macos-latest`, виклики скриптів, тригери `push` і `pull_request` для `develop` та `master`, відсутність секретів |

## 5. Commands

| Command | Передумови | Дії | Очікувані файли |
|---|---|---|---|
| `git-init` | Git-репозиторій, встановлений Git | Перевіряє work tree і гілку, створює або доповнює `.gitignore`, виконує `git status` | `.gitignore` |
| `create-project` | Git-репозиторій, `project-scaffold`, мова `python`, назва проєкту | Читає та виконує `project-scaffold`, не перезаписує файли, звітує про створені й пропущені елементи | `src/hello.py`, `README.md`, `src/`, `tests/`, `.gitignore` |
| `create-build` | `src/hello.py`, `build-and-test`, встановлений Python | Читає та виконує skill, запускає `./ci.sh` на Linux/macOS або `ci.bat` на Windows, показує результат | `requirements.txt`, `pytest.ini`, модуль із `add(a, b)`, `tests/test_basic.py`, `ci.sh`, `ci.bat`, `build/hello` |
| `create-actions` | `ci.sh`, `ci.bat`, `github-actions` | Читає та виконує skill, не дублює наявний workflow, показує створене або пропущене | `.github/workflows/ci.yml` |
| `check` | Git-репозиторій, встановлений Python | Read-only перевіряє шість груп: агент/skills/commands, проєкт, складання/тести, workflow, Git, журнал | Нові файли не створює; допускає лише побічні `.venv/` і `build/` від CI-скриптів |
| `init` | Git-репозиторій, Python, Git, усі п’ять commands і три skills | Послідовно запускає `git-init`, `create-project`, `create-build`, `create-actions`, `check`; після кожного кроку перевіряє результат | Файли, які створюють підпорядковані commands; формує підсумковий звіт |

## 6. Дані між етапами

- Мова `python` і назва проєкту визначаються один раз на початку `init`.
- `create-project` передає наступним етапам результат наявності `src/hello.py`, каталогів `src/` і `tests/`.
- `create-build` створює та передає далі `ci.sh` і `ci.bat`, а також результат `pytest` і build.
- `create-actions` використовує `ci.sh` і `ci.bat` для workflow.
- Після кожного кроку `init` збирає створені файли, пропущені наявні файли, код завершення та помилки.
- `check` отримує весь створений стан і перевіряє його цілісність без виправлення файлів.

## 7. Обробка помилок оркестратором

`init` перевіряє всі передумови до першого кроку. Після кожного кроку він перевіряє результат. При першій помилці оркестратор:

1. негайно зупиняється;
2. не запускає наступні commands;
3. повідомляє назву кроку, фактичну причину та command для окремого повторного запуску;
4. не оголошує роботу успішною.

Успіх можливий лише після виконання всіх п’яти кроків і завершення `check` без `FAIL`. Повторний запуск ідемпотентний: підпорядковані commands не перезаписують наявні файли та не дублюють конфігурацію.

## 8. Відповідність структурі з методички

| Рекомендований файл | Фактичний файл | Роль |
|---|---|---|
| Agent manifest | `.github/agents/build-engineer.agent.md` | Manifest custom agent для GitHub Copilot у VS Code |
| Skills | `.github/skills/<name>/SKILL.md` | On-demand процедури `project-scaffold`, `build-and-test`, `github-actions` |
| Commands/prompts | `.github/prompts/*.prompt.md` | Окремі команди та orchestrator `init` |
| `CMakeLists.txt` | `requirements.txt`, `pytest.ini`, `ci.sh`, `ci.bat` | Для Python CMake-конфігурація методички замінена залежностями, налаштуванням pytest і кросплатформними скриптами |
| Build/test workflow | `.github/workflows/ci.yml` | GitHub Actions CI з matrix для Ubuntu, Windows і macOS |

Формат агента відповідає GitHub Copilot у VS Code: manifest розташований у `.github/agents`, commands — у `.github/prompts`, skills — у `.github/skills`.

## 9. Обмеження агента

Агент:

- не робить коміти;
- не виконує `git push`, зокрема `git push --force`;
- не переписує історію Git і не змінює захист гілок;
- не видаляє файли;
- не публікує секрети та не записує їх у файли, логи або workflow;
- не запитує у користувача токени чи паролі;
- не обходить помилки успішними значеннями за замовчуванням;
- не додає build-каталоги, кеші, `venv` або секрети до Git.
