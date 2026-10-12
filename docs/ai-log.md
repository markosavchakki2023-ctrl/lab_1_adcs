# Журнал взаємодії з AI

## 1. Manifest агента
**Запит:** Створи файл .github/agents/build-engineer.agent.md: manifest спеціалізованого
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

Пиши українською, стисло й однозначно, без загальних фраз на кшталт "зроби проєкт".
**Результат:** створено .github/agents/build-engineer.agent.md
**Помилки / зауваження:** не виявлено"
**Рішення:** прийняв 