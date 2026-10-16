---
description: "Створи CI workflow для Python-проєкту через skill github-actions."
agent: "build-engineer"
---

# create-actions

## 1. Призначення

Створити CI workflow для Python-проєкту, викликавши skill [github-actions](../skills/github-actions/SKILL.md).

## 2. Передумови

- Існує `ci.sh`, створений командою `create-build`.
- Існує `ci.bat`, створений командою `create-build`.
- Існує [SKILL.md](../skills/github-actions/SKILL.md) для `github-actions`.

## 3. Дії по кроках

1. Перевір передумови: наявність `ci.sh`, `ci.bat` і skill `github-actions`.
2. Якщо `ci.sh` або `ci.bat` відсутній, зупинися та повідом: спочатку запусти `create-build`.
3. Прочитай [github-actions](../skills/github-actions/SKILL.md) повністю та виконай його вимоги.
4. Перед зміною `.github/workflows/ci.yml` перевір, чи файл уже існує, і прочитай його вміст.
5. Якщо workflow уже існує, не перезаписуй його без потреби та не дублюй наявну конфігурацію.
6. Після виконання покажи користувачу, що створено, а що пропущено, бо вже існувало.
7. Виконай команди перевірки з розділу 5 і зупинися при будь-якій помилці.

## 4. Очікувані файли

- `.github/workflows/ci.yml`

## 5. Команди перевірки

Перевір YAML доступним способом. Якщо встановлено PyYAML, виконай:

```text
python -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml', encoding='utf-8'))"
```

Якщо PyYAML недоступний, використай інший доступний YAML-валідатор і повідом, яку саме перевірку виконано.

Далі перевір, що:

- у matrix є `ubuntu-latest`, `windows-latest` і `macos-latest`;
- workflow викликає `./ci.sh` для Linux/macOS і `ci.bat` для Windows;
- у `strategy` встановлено `fail-fast: false`;
- Windows-крок має `if: runner.os == 'Windows'`, `shell: cmd` і `run: ci.bat`;
- workflow не містить власної логіки складання чи тестів, а лише викликає ці скрипти та завантажує результат;
- тригери `push` і `pull_request` налаштовані для `develop` та `master`;
- у файлі немає `secrets`, токенів, паролів або інших секретів.

## 6. Повідомлення про помилку

- Якщо немає `ci.sh` або `ci.bat`:

  `Помилка: не знайдено ci.sh або ci.bat. Спочатку запустіть команду create-build.`

- Якщо skill не знайдено:

  `Помилка: skill github-actions не знайдено за шляхом .github/skills/github-actions/SKILL.md. Створення workflow зупинено.`

- Якщо YAML невалідний:

  `Помилка: .github/workflows/ci.yml містить невалідний YAML. Перевірте відступи та синтаксис; фактичну помилку не приховано.`

- Якщо в matrix бракує ОС:

  `Помилка: matrix не містить усі необхідні ОС: ubuntu-latest, windows-latest і macos-latest. Workflow не вважається готовим.`

Для будь-якої іншої помилки покажи фактичну команду, код завершення та текст помилки. Не продовжуй після невдалого кроку.

## 7. Правила

- Нічого не видаляй.
- Не перезаписуй існуючий workflow без потреби та не дублюй його конфігурацію.
- Не роби коміти, `git push`, `git push --force`, `git reset` або інші force-операції.
- Не додавай секрети, токени або паролі.
- Повторний запуск не має руйнувати або дублювати існуючий workflow.
- При будь-якій помилці зупинися і не вважай результат успішним.
