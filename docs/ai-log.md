# Журнал взаємодії з AI

## 1. Manifest агента
**Запит:** ```Створи файл .github/agents/build-engineer.agent.md: manifest спеціалізованого
AI-агента "build-engineer" для GitHub Copilot у VS Code.

Контекст проєкту:
- Мова: Python, середовище venv, тестування pytest.
- Агент має створювати простий кросплатформний проєкт Hello World,
  автоматичне складання і юніт-тестування, CI на GitHub Actions
  (ubuntu-latest, windows-latest, macos-latest).
- Skills (у .github/skills/): project-scaffold, build-and-test, github-actions.
- Commands (у .github/prompts/): git-init, create-project, create-build,
  create-actions, check, init (init є оркестратором і запускає решту
  по черзі: git-init, create-project, create-build, create-actions, check).

Файл має починатися з YAML frontmatter (name, description, tools; використай
актуальний формат custom agents для VS Code), далі розділи markdown:

1. Роль агента.
2. Область відповідальності (що агент робить і чого не робить).
3. Доступні skills та commands, коли що застосовувати.
4. Правила роботи з файлами:
   - повторний запуск не руйнує існуючі файли і не дублює конфігурації;
   - перед зміною файлу перевіряти, чи він уже існує;
   - build-каталоги, кеші, venv, секрети не додавати до Git, лише в .gitignore.
5. Заборонені дії: видалення файлів, git push --force, переписування історії,
   зміна захисту гілок, публікація секретів, запит токенів/паролів у користувача.
6. Порядок роботи: перевірка передумов, виконання кроку, перевірка результату,
   зупинка при помилці з чітким повідомленням (без приховування помилок).
7. Критерії успішного завершення:
   - існує src/hello.py та команда його запуску;
   - тест BasicAddition у tests/ проходить через pytest;
   - ci.sh та ci.bat створюють venv, ставлять залежності, запускають тести;
   - .github/workflows/ci.yml лише викликає ці скрипти, має матрицю з трьома ОС;
   - у Git немає build-каталогів і секретів;
   - check завершується без помилок.

Пиши українською, стисло й однозначно, без загальних фраз на кшталт "зроби проєкт".```
**Результат:** створено .github/agents/build-engineer.agent.md
**Помилки / зауваження:** не виявлено
**Рішення:** прийняв 

## 2. Перший skill: project-scaffold
**Запит:** ```Створи файл .github/skills/project-scaffold/SKILL.md для агента build-engineer.

Skill описує створення мінімального Hello World-проєкту на Python (venv + pytest).

Файл має починатися з YAML frontmatter (name: project-scaffold, description:
коли застосовувати skill), далі розділи markdown:

Призначення і коли застосовувати.
Вхідні дані: мова (python) і назва проєкту.
Що створює: src/hello.py (виводить Hello, World!), README.md,
структуру каталогів src/ і tests/, початковий .gitignore
(.venv/, venv/, __pycache__/, .pytest_cache/, build/, dist/).
Правила: якщо файл уже існує, не перезаписувати і не дублювати рядки
в .gitignore; нічого не видаляти.
Перевірки результату: існує src/hello.py, його можна запустити
командою python src/hello.py, і він виводить Hello, World!.
Приклад входу та очікуваного результату.
Типовий сценарій помилки (наприклад, Python не знайдено) і що робити.
Пиши українською, стисло й однозначно.```
**Результат:** створено .github/skills/project-scaffold/SKILL.md
**Помилки/зауваження:** не виявлено
**Рішення:** прийняв

## 3. Другий skill: build-and-test
**Запит:** ``` Створи файл .github/skills/build-and-test/SKILL.md для агента build-engineer.

Skill описує створення системи складання та тестування для Python-проєкту
(venv + pytest), включно з тестовою функцією та юніт-тестом.

Файл має починатися з YAML frontmatter (name: build-and-test, description:
коли застосовувати skill), далі розділи markdown:

1. Призначення і коли застосовувати.
2. Вхідні дані: назва проєкту, наявність src/hello.py (результат skill
   project-scaffold).
3. Що створює:
   - requirements.txt з pytest;
   - pytest.ini (pythonpath = src);
   - тестову функцію add(a, b) у src/;
   - tests/test_basic.py з тестовим класом TestBasicAddition;
   - скрипти ci.sh (Linux/macOS) і ci.bat (Windows): створюють .venv,
     ставлять залежності, запускають pytest і генерують запускні файли
     hello / hello.bat у каталозі build/.
4. Правила: не перезаписувати існуючі файли, не дублювати рядки
   в конфігураціях, нічого не видаляти; скрипти повертають ненульовий
   код при помилці.
5. Перевірки результату: pytest проходить, тест BasicAddition виконується,
   build/hello запускається і виводить Hello, World!, каталог build/
   не потрапляє в Git.
6. Приклад входу та очікуваного результату.
7. Типовий сценарій помилки (наприклад, не вдалося створити venv, тест
   не проходить) і що робити.

Пиши українською, стисло й однозначно.```
**Результат:** створено ./github/build-and-test/SKILL.md
**Помилки / зауваженн:** була допущена помилка Copilot що до того які файли додавати до .gitignore. Після зауваження Copilot визнав сіою помилку і виправив.
**Рішення:** Прийняв виправлений варіант     