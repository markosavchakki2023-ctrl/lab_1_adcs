---
name: github-actions
description: "Застосовуй для створення та перевірки GitHub Actions workflow для Python-проєкту з venv, pytest і матрицею Ubuntu, Windows та macOS."
---

# GitHub Actions

## 1. Призначення і коли застосовувати

Skill створює workflow GitHub Actions для автоматичного запуску кросплатформного складання й тестування Python-проєкту. Застосовуй після `build-and-test`, коли готові `ci.sh` і `ci.bat`, а потрібно налаштувати CI для гілок `develop` і `master`.

## 2. Вхідні дані

- Наявний `ci.sh` для Linux/macOS.
- Наявний `ci.bat` для Windows.
- Скрипти вже створюють `.venv`, встановлюють залежності, запускають `pytest` і генерують `build/`.
- Назва проєкту для іменування artifact.

Якщо будь-який скрипт відсутній, спочатку застосуй `build-and-test` і не створюй workflow, який не зможе виконатися.

## 3. Що створює

Створи `.github/workflows/ci.yml` з такими вимогами:

- тригери `push` і `pull_request` лише для гілок `develop` та `master`;
- одна job із matrix, що містить `ubuntu-latest`, `windows-latest` і `macos-latest`;
- крок `actions/checkout@v4`;
- запуск `ci.sh` на Linux/macOS і `ci.bat` на Windows;
- завантаження каталогу `build/` через `actions/upload-artifact@v4`;
- ім’я artifact містить назву ОС, наприклад `${{ matrix.os }}`;
- workflow не містить власної логіки складання чи тестування: він лише викликає `ci.sh` або `ci.bat` і зберігає результат;
- у файлі немає секретів, токенів, паролів або їхніх значень.

Приклад структури workflow:

```yaml
name: CI

on:
  push:
    branches: [develop, master]
  pull_request:
    branches: [develop, master]

jobs:
  build-and-test:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    steps:
      - uses: actions/checkout@v4
      - name: Build and test on POSIX
        if: runner.os != 'Windows'
        run: ./ci.sh
      - name: Build and test on Windows
        if: runner.os == 'Windows'
        shell: cmd
        run: ci.bat
      - name: Upload build artifact
        uses: actions/upload-artifact@v4
        with:
          name: hello-${{ matrix.os }}
          path: build/
```

## 4. Правила

1. Перед створенням або зміною `.github/workflows/ci.yml` перевір, чи файл уже існує, і прочитай його вміст.
2. Не перезаписуй існуючий workflow без потреби; зберігай сумісні налаштування та не дублюй тригери, job або steps.
3. Нічого не видаляй.
4. Використовуй закріплені мажорні версії actions, наприклад `actions/checkout@v4` і `actions/upload-artifact@v4`; не використовуй `@main` або `@master`.
5. Не додавай у workflow власні команди для створення `venv`, встановлення залежностей, запуску pytest чи генерації build-файлів — це відповідальність `ci.sh` і `ci.bat`.
6. Не додавай секрети. Для цього workflow не потрібні `secrets.*`, токени або паролі.
7. На Linux/macOS забезпеч виконувані права `ci.sh`; на Windows викликай `ci.bat` через Windows runner.

## 5. Перевірки результату

Після створення перевір:

1. `ci.yml` є синтаксично валідним YAML.
2. У matrix присутні рівно `ubuntu-latest`, `windows-latest` і `macos-latest`.
3. Workflow містить виклик `ci.sh` для Linux/macOS і `ci.bat` для Windows.
4. Є крок `actions/checkout@v4` і крок `actions/upload-artifact@v4` із `path: build/`.
5. Тригери `push` і `pull_request` налаштовані для `develop` та `master`.
6. Workflow не містить власної логіки складання чи тестів і не містить секретів.
7. `ci.sh` має право на виконання, а `ci.bat` існує.

Якщо будь-яка перевірка не проходить, зупинись і повідом точну перевірку, команду та текст помилки.

## 6. Приклад входу та очікуваного результату

Вхід:

```text
Назва проєкту: hello-world
ci.sh: існує та має право на виконання
ci.bat: існує
```

Очікуваний результат:

```text
.github/
└── workflows/
    └── ci.yml
```

Workflow запускається для `push` і `pull_request` у `develop` та `master`, виконує `ci.sh` або `ci.bat` на кожній із трьох ОС і створює artifact `hello-<назва-ОС>` з каталогу `build/`.

## 7. Типові сценарії помилки

- Якщо Linux/macOS runner не може виконати `ci.sh`, перевір право виконання та виправ його через `chmod +x ci.sh`. Не замінюй виклик скрипта прихованою логікою в workflow.
- Якщо `ci.bat` відсутній, зупинись і спочатку застосуй `build-and-test`; не прибирай Windows із matrix.
- Якщо Windows runner не знаходить `ci.bat`, перевір, що крок має `shell: cmd`; PowerShell не запускає скрипти з поточного каталогу без префікса `.\`.
- Якщо падіння одного job скасовує інші, перевір, що в `strategy` встановлено `fail-fast: false`.
- Якщо YAML невалідний, виправ відступи, умови та вирази matrix, після чого повтори перевірку.
- Якщо artifact не завантажується, перевір, що `ci.sh` або `ci.bat` завершилися успішно та створили `build/`; не маскуй помилку `upload-artifact`.
