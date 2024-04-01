#Область ПрограммныйИнтерфейс

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его по указанному пути на сервере.
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>.
//   ПараметрыПолучения - Структура - см. ОбщегоНазначенияКлиентСервер.ПараметрыПолученияФайла.
//   ЗаписыватьОшибку   - Булево - Признак необходимости записи ошибки в журнал регистрации при получении файла.
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус            - Булево - результат получения файла.
//      * Путь   - Строка   - путь к файлу на сервере, ключ используется только если статус Истина.
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь.
//      * Заголовки         - Соответствие - см. в синтаксис-помощнике описание параметра Заголовки объекта HTTPОтвет.
//      * КодСостояния      - Число - Добавляется при возникновении ошибки.
//                                    См. в синтаксис-помощнике описание параметра КодСостояния объекта HTTPОтвет.
//
Функция СкачатьФайлНаСервере(Знач URL, ПараметрыПолучения = Неопределено, Знач ЗаписыватьОшибку = Истина) Экспорт
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "Сервер");
	
	Возврат ПолучениеФайловИзИнтернетаКлиентСервер.ПодготовитьПолучениеФайла(URL,
		ПараметрыПолучения, НастройкаСохранения, ЗаписыватьОшибку);
	
КонецФункции

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его во временное хранилище.
// Примечание: После получения файла временное хранилище необходимо самостоятельно очистить
// при помощи метода УдалитьИзВременногоХранилища. Если этого не сделать, то файл будет находиться
// в памяти сервера до конца сеанса.
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>.
//   ПараметрыПолучения - Структура - см. ОбщегоНазначенияКлиентСервер.ПараметрыПолученияФайла.
//   ЗаписыватьОшибку   - Булево - Признак необходимости записи ошибки в журнал регистрации при получении файла.
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус            - Булево - результат получения файла.
//      * Путь   - Строка   - адрес временного хранилища с двоичными данными файла,
//                            ключ используется только если статус Истина.
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь.
//      * Заголовки         - Соответствие - см. в синтаксис-помощнике описание параметра Заголовки объекта HTTPОтвет.
//      * КодСостояния      - Число - Добавляется при возникновении ошибки.
//                                    См. в синтаксис-помощнике описание параметра КодСостояния объекта HTTPОтвет.
//
Функция СкачатьФайлВоВременноеХранилище(Знач URL, ПараметрыПолучения = Неопределено, Знач ЗаписыватьОшибку = Истина) Экспорт
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "ВременноеХранилище");
	
	Возврат ПолучениеФайловИзИнтернетаКлиентСервер.ПодготовитьПолучениеФайла(URL,
		ПараметрыПолучения, НастройкаСохранения, ЗаписыватьОшибку);
	
КонецФункции

// Возвращает настройку прокси сервера для доступа в Интернет со стороны
// клиента для текущего пользователя.
//
// Возвращаемое значение:
//   Соответствие - свойства:
//		ИспользоватьПрокси - использовать ли прокси-сервер.
//		НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов.
//		ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера.
//		Сервер       - адрес прокси-сервера.
//		Порт         - порт прокси-сервера.
//		Пользователь - имя пользователя для авторизации на прокси-сервере.
//		Пароль       - пароль пользователя.
//
Функция НастройкиПроксиНаКлиенте() Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкаПроксиСервера", "");
	
КонецФункции

// Возвращает параметры настройки прокси-сервера на стороне сервера 1С:Предприятие.
//
// Возвращаемое значение:
//   Соответствие - свойства:
//		ИспользоватьПрокси - использовать ли прокси-сервер.
//		НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов.
//		ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера.
//		Сервер       - адрес прокси-сервера.
//		Порт         - порт прокси-сервера.
//		Пользователь - имя пользователя для авторизации на прокси-сервере.
//		Пароль       - пароль пользователя.
//
Функция НастройкиПроксиНаСервере() Экспорт
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат НастройкиПроксиНаКлиенте();
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		НастройкиПроксиНаСервере = Константы.НастройкаПроксиСервера.Получить().Получить();
		Возврат ?(ТипЗнч(НастройкиПроксиНаСервере) = Тип("Соответствие"),
				  НастройкиПроксиНаСервере,
				  Неопределено);
	КонецЕсли;
	
КонецФункции

#КонецОбласти
