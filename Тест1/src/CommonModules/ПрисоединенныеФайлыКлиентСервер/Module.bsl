////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события.

// Устарела.
// Следует использовать РаботаСФайлами.ОпределитьФормуПрисоединенногоФайла.
// Обработчик подписки на событие ОбработкаПолученияФормы для переопределения формы файла.
//
// Параметры:
//  Источник                 - СправочникМенеджер - менеджер справочника с именем "*ПрисоединенныеФайлы".
//  ВидФормы                 - Строка - имя стандартной формы.
//  Параметры                - Структура - параметры формы.
//  ВыбраннаяФорма           - Строка - имя или объект метаданных открываемой формы.
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы.
//  СтандартнаяОбработка     - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ПереопределитьПолучаемуюФормуПрисоединенногоФайла(Источник,
                                                      ВидФормы,
                                                      Параметры,
                                                      ВыбраннаяФорма,
                                                      ДополнительнаяИнформация,
                                                      СтандартнаяОбработка) Экспорт
	
	РаботаСФайламиСлужебныйВызовСервера.ОпределитьФормуПрисоединенногоФайла(
		Источник,
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти
