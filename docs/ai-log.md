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
**Запит:** ```Створи файл .github/skills/build-and-test/SKILL.md для агента build-engineer.

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
**Помилки / зауваженн:** була допущена помилка Copilot що до того які файли додавати до .gitignore. Після зауваження Copilot визнав свою помилку і виправив.
**Рішення:** Прийняв виправлений варіант    

## 4. Треетій skill: github-actions
**Запит:** ```Створи файл .github/skills/github-actions/SKILL.md для агента build-engineer.

Skill описує створення .github/workflows/ci.yml для Python-проєкту
(venv + pytest) з матрицею Windows, Linux і macOS.

Файл має починатися з YAML frontmatter (name: github-actions, description:
коли застосовувати skill), далі розділи markdown:

1. Призначення і коли застосовувати.
2. Вхідні дані: наявність ci.sh і ci.bat (результат skill build-and-test).
3. Що створює: .github/workflows/ci.yml з такими вимогами:
   - тригери: push і pull_request для гілок develop та master;
   - одна job з matrix: ubuntu-latest, windows-latest, macos-latest;
   - кроки: checkout, запуск скрипта збірки (ci.sh на Linux/macOS,
     ci.bat на Windows), збереження каталогу build/ як artifact
     (actions/upload-artifact) з іменем, що містить назву ОС;
   - workflow НЕ містить власної логіки збірки чи тестів: лише виклик
     ci.sh або ci.bat;
   - жодних секретів у файлі.
4. Правила: не перезаписувати існуючий ci.yml без потреби, не дублювати
   конфігурацію, нічого не видаляти; використовувати закріплені
   мажорні версії actions (наприклад, actions/checkout@v4).
5. Перевірки результату: YAML валідний, у matrix є всі три ОС,
   у workflow є виклики ci.sh та ci.bat, секретів немає.
6. Приклад входу та очікуваного результату.
7. Типовий сценарій помилки (наприклад, ci.sh не має прав на виконання
   на Linux/macOS, або відсутній ci.bat) і що робити.

Пиши українською, стисло й однозначно.```
**Результат:** створено .github/skills/github-action/SKILL.md
**Помилки / зауваженн:** не виявлено
**Рішення:** Прийняв

## 5. Перша command: git-init
**Запит:** ```Створи файл .github/prompts/git-init.prompt.md: команду "git-init" для
агента build-engineer.

Файл має починатися з YAML frontmatter (description: короткий опис команди,
agent: build-engineer; використай актуальний формат prompt files для
VS Code), далі розділи markdown:

1. Призначення: перевірити Git-репозиторій, створити або оновити
   .gitignore, показати стан Git.
2. Передумови: каталог є Git-репозиторієм (є .git), Git встановлено.
3. Дії по кроках:
   - перевірити, що це репозиторій, і показати поточну гілку;
   - якщо .gitignore немає, створити його; якщо є, додати лише ті рядки,
     яких бракує (.venv/, venv/, __pycache__/, .pytest_cache/, build/,
     dist/), не дублюючи наявні;
   - виконати git status і показати результат користувачу.
4. Очікувані файли: .gitignore.
5. Команди перевірки: git rev-parse --is-inside-work-tree,
   git status, перевірка, що в .gitignore немає дублікатів.
6. Повідомлення про помилку: окремі зрозумілі тексти для випадків,
   коли це не Git-репозиторій, коли Git не встановлено.
7. Правила: команда лише читає стан і додає рядки до .gitignore;
   вона нічого не видаляє, не робить коміти, push, reset чи force-операцій;
   повторний запуск не змінює результат.

Пиши українською, стисло й однозначно.```
**Результат:** створено .github/prompts/git-/SKILL.md
**Помилки / зауваження:** не виявлено
**Рішення:** Прийняв

## 6. Друга команда: create-project 
**Запит:** ```Створи файл .github/prompts/create-project.prompt.md: команду
"create-project" для агента build-engineer.

Файл має починатися з YAML frontmatter (description: короткий опис команди,
agent: build-engineer; використай той самий формат, що в
.github/prompts/git-init.prompt.md), далі розділи markdown:

Призначення: створити початковий Hello World-проєкт на Python,
викликавши skill project-scaffold (.github/skills/project-scaffold/SKILL.md).
Передумови: каталог є Git-репозиторієм, існує skill project-scaffold,
визначені мова (python) і назва проєкту.
Дії по кроках:
перевірити передумови;
прочитати skill project-scaffold і виконати його з вхідними даними
(мова, назва проєкту);
не перезаписувати вже існуючі файли;
показати користувачу список створених і пропущених файлів.
Очікувані файли: src/hello.py, README.md, каталоги src/ і tests/,
.gitignore.
Команди перевірки: python src/hello.py виводить Hello, World!;
перевірка наявності src/hello.py.
Повідомлення про помилку: окремі зрозумілі тексти для випадків,
коли skill не знайдено, коли Python не знайдено, коли src/hello.py
не створився або не запускається.
Правила: команда нічого не видаляє, не робить коміти і push;
повторний запуск не руйнує і не дублює існуючі файли.
Пиши українською, стисло й однозначно.``` 
**Результат:** створено .github/prompts/create-project.md
**Помилки / зауваження:** не виявлено
**Рішення:** прийняв

## 7. Третя команда: create-build
**Запит:** ```Створи файл .github/prompts/create-build.prompt.md: команду
"create-build" для агента build-engineer.

Файл має починатися з YAML frontmatter (description: короткий опис команди,
agent: build-engineer; використай той самий формат, що в
.github/prompts/git-init.prompt.md і create-project.prompt.md), далі
розділи markdown:

1. Призначення: створити конфігурацію складання і тести для Python-проєкту
   (venv + pytest), викликавши skill build-and-test
   (.github/skills/build-and-test/SKILL.md).
2. Передумови: існує src/hello.py (результат команди create-project),
   існує skill build-and-test, встановлено Python.
3. Дії по кроках:
   - перевірити передумови, а якщо src/hello.py немає, зупинитися
     з повідомленням запустити спочатку create-project;
   - прочитати skill build-and-test і виконати його;
   - не перезаписувати вже існуючі файли і не дублювати рядки
     в конфігураціях;
   - запустити ci.sh (або ci.bat на Windows) і показати результат
     складання та тестів.
4. Очікувані файли: requirements.txt, pytest.ini, функція add(a, b) у src/,
   tests/test_basic.py з тестом BasicAddition, ci.sh, ci.bat, виконуваний
   запускний файл hello у каталозі build/.
5. Команди перевірки: pytest проходить, тест BasicAddition виконується,
   build/hello запускається і виводить Hello, World!, каталог build/
   не відстежується Git (git status його не показує).
6. Повідомлення про помилку: окремі зрозумілі тексти для випадків,
   коли немає src/hello.py, коли не вдалося створити venv чи встановити
   залежності, коли тест не проходить.
7. Правила: команда нічого не видаляє, не робить коміти і push;
   повторний запуск не руйнує і не дублює існуючі файли; при помилці
   зупиняється і не вважає результат успішним.

Пиши українською, стисло й однозначно.```
**Результат:** створено .github/prompts/create-build.prompt.md
**Помилки / зауваження:**  було зауваження щодо розділу команди перевірки. Запитав у Copilot про це і він оновив розділ.
**Рішення:** прийняв оновлений варіант

## 8. Четверта команда: create-action
**Запит:** ```Створи файл .github/prompts/create-actions.prompt.md: команду
"create-actions" для агента build-engineer.

Файл має починатися з YAML frontmatter (description: короткий опис команди,
agent: build-engineer; використай той самий формат, що в
.github/prompts/git-init.prompt.md, create-project.prompt.md і
create-build.prompt.md), далі розділи markdown:

1. Призначення: створити CI workflow для Python-проєкту, викликавши
   skill github-actions (.github/skills/github-actions/SKILL.md).
2. Передумови: існують ci.sh і ci.bat (результат команди create-build),
   існує skill github-actions.
3. Дії по кроках:
   - перевірити передумови, а якщо ci.sh або ci.bat немає, зупинитися
     з повідомленням запустити спочатку create-build;
   - прочитати skill github-actions і виконати його;
   - якщо .github/workflows/ci.yml уже існує, не перезаписувати його
     без потреби і не дублювати конфігурацію;
   - показати користувачу, що створено або пропущено.
4. Очікувані файли: .github/workflows/ci.yml.
5. Команди перевірки: YAML валідний (наприклад, через
   python -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))"
   або інший доступний спосіб); у matrix є ubuntu-latest, windows-latest,
   macos-latest; workflow лише викликає ci.sh і ci.bat, без власної логіки
   збірки чи тестів; тригери push і pull_request для develop та master;
   у файлі немає секретів.
6. Повідомлення про помилку: окремі зрозумілі тексти для випадків,
   коли немає ci.sh чи ci.bat, коли YAML невалідний, коли в matrix
   бракує якоїсь ОС.
7. Правила: команда нічого не видаляє, не робить коміти і push;
   повторний запуск не руйнує і не дублює існуючий workflow; при помилці
   зупиняється і не вважає результат успішним.

Пиши українською, стисло й однозначно.```
**Результат:** створено .github/prompts/create-action-prompt.md
**Помилки / зауваження:** не виявлено
**Рішенн:** прийняв

## 9. П'ята команда: check
**Запит:** ```Створи файл .github/prompts/check.prompt.md: команду "check" для агента
build-engineer.

Файл має починатися з YAML frontmatter (description: короткий опис команди,
agent: build-engineer; використай той самий формат, що в інших файлах
у .github/prompts/), далі розділи markdown:

1. Призначення: перевірити структуру, конфігурацію, складання, тести та
   YAML workflow. Команда НЕ змінює файли проєкту, а лише читає і перевіряє.
2. Передумови: каталог є Git-репозиторієм, встановлено Python.
3. Перевірки по групах (кожна дає PASS або FAIL з поясненням):
   а) агент: існує .github/agents/build-engineer.agent.md і містить роль,
      обмеження (заборонені дії) та критерії завершення; існують три skills,
      у кожному є призначення, входи, виходи, перевірки; існують команди
      git-init, create-project, create-build, create-actions, check, init;
      init викликає команди в порядку git-init, create-project,
      create-build, create-actions, check;
   б) проєкт: існують src/hello.py, tests/test_basic.py, requirements.txt,
      ci.sh, ci.bat, README.md, .gitignore;
   в) складання і тести: запустити ci.sh (або ci.bat на Windows),
      pytest проходить, тест BasicAddition виконується, build/hello
      запускається і виводить Hello, World!;
   г) workflow: .github/workflows/ci.yml валідний YAML, у matrix є
      ubuntu-latest, windows-latest, macos-latest, workflow лише викликає
      ci.sh і ci.bat, тригери push і pull_request для develop та master;
   д) Git: git ls-files не містить build/, .venv/, __pycache__/,
      .pytest_cache/; у відстежуваних файлах немає секретів (токени,
      паролі, приватні ключі);
   е) журнал: існує docs/ai-log.md.
4. Допустимі побічні ефекти: ci.sh/ci.bat можуть створювати .venv/ і build/,
   які ігноруються Git; відстежувані файли check не змінює.
5. Формат звіту: таблиця або список "перевірка: PASS/FAIL (причина)" і
   підсумок. Якщо є хоча б один FAIL, команда завершується з помилкою
   і явно каже, що результат НЕ прийнятий.
6. Повідомлення про помилку: для кожної групи перевірок окремий зрозумілий
   текст із підказкою, яку команду запустити для виправлення
   (наприклад, create-build).
7. Правила: команда нічого не видаляє, не виправляє файли самостійно,
   не робить коміти і push; не приховує помилки і не вважає роботу
   успішною без виконання всіх перевірок.

Пиши українською, стисло й однозначно.```
**Результат:** створено .github/prompts/check.propmt.md
**Помилки / зауваження:** невиявлено
**Рішення:** Прийняв

## 10. Шоста команда: init
**Запит:** ```Створи файл .github/prompts/init.prompt.md: команду-оркестратор "init"
для агента build-engineer.

Файл має починатися з YAML frontmatter (description: короткий опис команди,
agent: build-engineer; використай той самий формат, що в інших файлах
у .github/prompts/), далі розділи markdown:

1. Призначення: повний сценарій створення проєкту. Послідовно запустити
   команди git-init, create-project, create-build, create-actions, check
   і видати підсумковий звіт. Сама init не містить логіки створення файлів,
   вона лише координує інші команди.
2. Передумови: каталог є Git-репозиторієм, існують усі п'ять команд
   у .github/prompts/ та три skills у .github/skills/, встановлено
   Python і Git. Перевірити їх до запуску першого кроку.
3. Порядок виконання (суворо за списком):
   1) git-init
   2) create-project
   3) create-build
   4) create-actions
   5) check
   Після кожного кроку перевірити його результат. Якщо крок завершився
   помилкою, негайно зупинитися, не запускати наступні кроки і показати,
   на якому кроці та чому сталася помилка.
4. Дані між етапами: назва проєкту і мова (python) визначаються один раз
   на початку і передаються далі; результат кожного кроку (створені
   і пропущені файли) збирається для підсумкового звіту.
5. Підсумковий звіт: таблиця "крок: OK/FAIL, створені файли, пропущені
   файли" і результат check. Успіх оголошується лише якщо всі п'ять кроків
   пройшли, а check не має жодного FAIL.
6. Повідомлення про помилку: окремі зрозумілі тексти для відсутньої
   команди чи skill, для помилки на конкретному кроці (із вказанням,
   яку команду запустити окремо після виправлення).
7. Правила: повторний запуск init не руйнує і не дублює вже створені
   файли (кожна команда ідемпотентна); init нічого не видаляє, не робить
   коміти, push, reset чи force-операції; не приховує помилки і не вважає
   роботу успішною без check.

Пиши українською, стисло й однозначно.```
**Резульат:** створено .github/prompts/init.prompt.md
**Помилки / зауваження:** не виявлено
**Рішення:** прийняв

## 11. Створення architectre.md
**Запит:** ```Створи файл docs/architecture.md з описом архітектури AI-агента build-engineer.

Спочатку прочитай уже створені файли: .github/agents/build-engineer.agent.md,
усі SKILL.md у .github/skills/ та всі файли в .github/prompts/. Опис має
точно відповідати їхньому вмісту, нічого не вигадуй.

Розділи markdown:

1. Призначення: які проблеми вирішує агент (автоматичне створення
   Python-проєкту Hello World з venv і pytest, системи складання, тестів
   і CI для Windows, Linux, macOS; повторюваність результату).
2. Склад агента: таблиця "елемент | файл | роль" для manifest, трьох skills,
   шести commands. Для orchestrator (init) окремо вкажи, що він координує
   решту команд.
3. Схема взаємодії: ASCII-схема або mermaid-діаграма, де видно, що init
   послідовно викликає git-init, create-project, create-build,
   create-actions, check, а команди create-* викликають відповідні skills
   (project-scaffold, build-and-test, github-actions).
4. Skills: для кожного коротко призначення, вхід, вихід, перевірка.
5. Commands: для кожної коротко передумови, дії, очікувані файли.
6. Дані між етапами: що передається від кроку до кроку (мова, назва
   проєкту, результати кроків, наявність src/hello.py, ci.sh, ci.bat).
7. Обробка помилок оркестратором: зупинка при першій помилці, звіт про
   крок і причину, успіх лише після check без FAIL, ідемпотентність
   повторного запуску.
8. Відповідність структурі з методички: таблиця "рекомендований файл |
   фактичний файл | роль". Зазнач, що CMakeLists.txt з методички замінено
   для Python на requirements.txt, pytest.ini та скрипти ci.sh/ci.bat,
   а формат агента відповідає GitHub Copilot у VS Code
   (.github/agents, .github/prompts, .github/skills).
9. Обмеження агента: що він не робить (не комітить, не пушить, не видаляє
   файли, не працює з секретами).

Пиши українською, стисло й однозначно.```
**Результат:** створено docs/architecture.md
**Помилки / зауваження:** не виявлено
**Рішення:** прийняв

## 12. Створення usage.md
**Запит:** ```Створи файл docs/usage.md з інструкцією запуску AI-агента build-engineer
та локальної перевірки результату.

Спочатку прочитай .github/agents/build-engineer.agent.md, файли в
.github/prompts/ та .github/skills/. Назви команд, файлів і кроки мають
точно відповідати їхньому вмісту, нічого не вигадуй.

Розділи markdown:

1. Вимоги до середовища: VS Code з розширенням GitHub Copilot і входом
   під акаунтом зі студентським доступом, Git, Python 3.
2. Запуск агента:
   - відкрити репозиторій у VS Code, відкрити Copilot Chat;
   - вибрати агента build-engineer;
   - запустити повний сценарій командою /init;
   - окремі команди: /git-init, /create-project, /create-build,
     /create-actions, /check (для кожної один рядок: що робить і коли
     запускати).
3. Очікуваний результат після /init: перелік файлів, які мають з'явитися
   (src/hello.py, tests/test_basic.py, requirements.txt, pytest.ini,
   ci.sh, ci.bat, .github/workflows/ci.yml).
4. Локальна перевірка без агента:
   - Windows (PowerShell): .\ci.bat
   - Linux/macOS: chmod +x ci.sh, потім ./ci.sh
   - що саме роблять скрипти (venv, залежності, pytest, build/).
5. Запуск зібраного проєкту:
   - Windows: build\hello.bat
   - Linux/macOS: ./build/hello
   - очікуваний вивід: Hello, World!
6. Запуск тестів окремо: активація .venv і команда pytest; очікуваний
   результат, у якому видно тест BasicAddition.
7. Повторний запуск: /init можна запускати повторно, існуючі файли
   не руйнуються і не дублюються.
8. Типові проблеми: Python не знайдено, немає прав на ci.sh,
   Copilot не бачить агента; для кожної вказати, що робити.

Пиши українською, стисло й однозначно.```
**Резульат:** створено docs/usage.md
**Помилки / зауваження:** не виявлено
**Рішення:** прийняв

## 13. Доповнення README.md
**Запит:** ```Онови файл README.md. Існуючі дані (ПІП, група, варіант) не змінюй і не
видаляй. Додай або оновити лише такі секції:

1. Короткий опис проєкту: AI-агент build-engineer для GitHub Copilot у
   VS Code, який створює Python-проєкт Hello World (venv + pytest) із
   системою складання, тестами і CI для Windows, Linux, macOS.
2. Запуск агента: коротко (3-5 рядків): відкрити репозиторій у VS Code,
   відкрити Copilot Chat, вибрати агента build-engineer, запустити /init.
   Також перелічити окремі команди: /git-init, /create-project,
   /create-build, /create-actions, /check.
3. Запуск зібраного проєкту та тестів: коротко, з посиланням на
   docs/usage.md для деталей.
4. Структура репозиторію: короткий перелік ключових каталогів і файлів
   агента (.github/agents, .github/prompts, .github/skills) та посилання
   на docs/architecture.md.
5. Гілки: develop містить агента, feature/... містить повний проєкт,
   результат згенерований запуском агента.

Перед змінами прочитай docs/usage.md і docs/architecture.md, інформація
має з ними збігатися. Пиши українською, стисло.```
**Результат:** доповнено README.md
**Помилки / зауваження:** не виявлено
**Рішення:** прийняв

## 14. Спроба запуску агента за допомгою команди init
**Запит:** ввів Copilot команду /init
**Резултат:** Copilot виконав вбудовану команду /init, яка генерує файл інструкцій для репозиторію і створив .github/copilot-instructions.md. Назва збіглася з моєю init.prompt.md, тому вбудована команда «перехопила» запуск.
**Помилки / зауваження:** помилка зі сторони Copilot яку команду виконувати
**Рішення:** видалив зайвий файл і спробував через палітру команд виконати потрібну команду за допмогою Chat: Run Prompt, але безуспішно, тому прийняв рішення змінити назву власної команди.
**Запит для переіменування init на init-project та внесення змін до необхідних файлів:** ```Команду-оркестратор в цьому репозиторії перейменовано з "init" на
"init-project" (файл .github/prompts/init-project.prompt.md), бо назва init
збігається з вбудованою командою Copilot і запускає її замість нашої.

Онови всі згадки назви нашої команди з init на init-project у файлах:
.github/agents/build-engineer.agent.md, .github/prompts/ (зокрема в самому
init-project.prompt.md та check.prompt.md), .github/skills/,
README.md, docs/architecture.md, docs/usage.md.

Заміни тільки згадки нашої команди-оркестратора (наприклад, /init у
інструкціях запуску). Не чіпай слова "init" в інших значеннях
(наприклад, git init, "ініціалізація").

У docs/architecture.md додай коротке пояснення, чому команда має назву
init-project: назва init займається вбудованою командою Copilot.

Нічого не видаляй. Після змін покажи список змінених файлів.```
У результат була змінена назва команди і внесені зміни до файлів.

## 15. Запуску після зміни назви
Після виконання команди init-project усе створилося успішно. Запущений hello.bat файл працює добре. Виконання команди check також завершилося успішно 

## 16. Виравлення проблем з CI 
**Зпит:** ```Під час першого запуску CI у GitHub Actions виявлено помилки:
1) Linux/macOS: "./ci.sh: Permission denied" (код 126), бо ci.sh у Git
   має режим 100644.
2) Windows: у PowerShell "ci.bat is not recognized", бо PowerShell не
   запускає скрипти з поточного каталогу без ".\".
3) Через fail-fast падіння одного job скасувало інші.

Онови skills і commands так, щоб це не повторювалось:

- .github/skills/github-actions/SKILL.md: у ci.yml використовувати
  strategy fail-fast: false; окремі кроки запуску: для Linux/macOS
  "if: runner.os != 'Windows'" з run: ./ci.sh, для Windows
  "if: runner.os == 'Windows'" з shell: cmd і run: ci.bat. Workflow
  по-старому лише викликає скрипти.
- .github/skills/build-and-test/SKILL.md: після створення ci.sh виставити
  право на виконання в індексі Git командою
  git update-index --add --chmod=+x ci.sh (без коміту); створити
  .gitattributes із рядками "*.sh text eol=lf" і "*.bat text eol=crlf",
  не дублюючи наявні рядки.
- .github/prompts/check.prompt.md: додати перевірки, що
  git ls-files --stage ci.sh показує 100755, існує .gitattributes,
  у ci.yml є fail-fast: false і shell: cmd для Windows.
- В обох skills додати ці випадки в розділ типових помилок.

Змінюй мінімально, нічого не видаляй. Покажи список змінених файлів.```

У результаті github actions для windows стали працювати а для Linux та macos ще не працюють. Після запиту тепер jobs для windows справні а для linux та macos ні copilot вніс зміни до файлів .github/build-and-test/SKILL.md та ci.sh
