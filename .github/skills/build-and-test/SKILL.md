---
name: build-and-test
description: "Застосовуй для створення та перевірки системи складання і тестування Python-проєкту з venv, pytest, тестовою функцією add та скриптами CI для Linux, macOS і Windows."
---

# Build and Test

## 1. Призначення і коли застосовувати

Skill додає до мінімального Python-проєкту локальне складання, юніт-тестування та кросплатформні CI-скрипти. Застосовуй після `project-scaffold`, коли вже існує `src/hello.py` і потрібні `venv`, `pytest`, тест `BasicAddition` та запускний артефакт у `build/`.

## 2. Вхідні дані

- Назва проєкту.
- Мова: `python`.
- Наявний файл `src/hello.py`, створений skill `project-scaffold`.
- Наявні каталоги `src/` і `tests/`.

Якщо `src/hello.py` відсутній, спочатку застосуй `project-scaffold` і не створюй дубльований scaffold у цьому skill.

## 3. Що створює

Створи лише відсутні файли та каталоги:

- `requirements.txt` з залежністю `pytest`;
- `pytest.ini` з налаштуванням `pythonpath = src`;
- у модулі в `src/` тестову функцію `add(a, b)`, яка повертає суму `a + b`;
- `tests/test_basic.py` з класом `TestBasicAddition` і тестом виклику `add(2, 3)`, що очікує `5`;
- `ci.sh` для Linux/macOS;
- `ci.bat` для Windows.
- `.gitattributes` з правилами `*.sh text eol=lf` і `*.bat text eol=crlf`.

Скрипт `ci.sh` на Linux/macOS має використовувати доступний POSIX-інтерпретатор `python3`, а `ci.bat` на Windows — команду `python`. Обидва скрипти повинні:

1. створювати `.venv`, якщо його немає;
2. встановлювати залежності з `requirements.txt` через Python цього середовища;
3. запускати `pytest`;
4. створювати каталог `build/`;
5. генерувати запускні файли `build/hello` і `build/hello.bat`, які запускають `src/hello.py`.

Після створення `ci.sh` вистав режим виконання в індексі Git без коміту:

```text
git update-index --add --chmod=+x ci.sh
```

Додай до `.gitattributes` лише відсутні рядки:

```text
*.sh text eol=lf
*.bat text eol=crlf
```

Скрипти мають зупинятися на першій помилці та повертати ненульовий код завершення. Не додавай `.venv/` або `build/` до Git: вони мають бути виключені в `.gitignore`.

## 4. Правила

1. Перед зміною кожного файлу перевір, чи він існує, і прочитай його вміст.
2. Не перезаписуй існуючі файли; зберігай сумісний наявний вміст і додавай лише відсутню необхідну конфігурацію.
3. Не дублюй рядки в `requirements.txt`, `pytest.ini`, скриптах або `.gitignore`.
4. Нічого не видаляй.
5. Не додавай секрети, локальні середовища, кеші чи каталог `build/` до Git.
6. Використовуй окремі команди активації/інтерпретатори для POSIX і Windows; не припускай, що `bash` доступний у `ci.bat` або `cmd.exe` доступний у `ci.sh`.

## 5. Перевірки результату

Після створення виконай:

1. `ci.sh` на Linux/macOS або `ci.bat` на Windows; він має завершитися з кодом `0`.
2. `pytest`; тест `TestBasicAddition` має виконатися і пройти.
3. `build/hello` на Linux/macOS або `build/hello.bat` на Windows; вивід має містити `Hello, World!`.
4. Перевір, що `build/`, `.venv/`, `venv/`, `__pycache__/` і `.pytest_cache/` виключені з Git через `.gitignore`.
5. Перевір, що скрипти повертають ненульовий код при невдалій установці залежностей або проваленому тесті.

Якщо будь-яка перевірка не проходить, зупинись і повідом точну команду, код завершення та текст помилки.

## 6. Приклад входу та очікуваного результату

Вхід:

```text
Назва проєкту: hello-world
src/hello.py: існує
```

Очікувані файли:

```text
hello-world/
├── ci.bat
├── ci.sh
├── pytest.ini
├── requirements.txt
├── src/
│   ├── hello.py
│   └── operations.py
└── tests/
    └── test_basic.py
```

Після успішного запуску CI:

```text
pytest: passed
build/hello: Hello, World!
```

## 7. Типові сценарії помилки

- Якщо не вдалося створити `.venv`, перевір доступність Python і права запису в каталог. Не продовжуй зі системним Python, якщо скрипт очікує ізольоване середовище.
- Якщо встановлення `pytest` не вдалося, повідом мережеву або версійну помилку та поверни ненульовий код.
- Якщо тест `TestBasicAddition` не проходить, зупини CI, покажи traceback і виправляй причину в коді або тесті лише після перевірки наявних файлів; не маскуй провал тесту.
- Якщо Linux/macOS повідомляє `./ci.sh: Permission denied` або код `126`, перевір режим `git ls-files --stage ci.sh` і виконай `git update-index --add --chmod=+x ci.sh` без коміту.
- Якщо Windows не знаходить `ci.bat` у PowerShell, запускай його у workflow з `shell: cmd` і `run: ci.bat`, а не через PowerShell.
- Якщо змішані кінці рядків ламають скрипти, перевір `.gitattributes` і правила `*.sh text eol=lf` та `*.bat text eol=crlf`.
