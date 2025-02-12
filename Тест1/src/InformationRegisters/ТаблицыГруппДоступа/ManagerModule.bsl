#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура обновляет данные регистра по результату изменения прав ролей,
// сохраненному при обновлении регистра сведений ПраваРолей.
//
Процедура ОбновитьДанныеРегистраПоИзменениямКонфигурации() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоследниеИзменения = СтандартныеПодсистемыСервер.ИзмененияПараметраРаботыПрограммы(
		"СтандартныеПодсистемы.УправлениеДоступом.ОбъектыМетаданныхПравРолей");
	
	Если ПоследниеИзменения = Неопределено Тогда
		ОбновитьДанныеРегистра();
	Иначе
		ОбъектыМетаданных = Новый Массив;
		Для каждого ЧастьИзменений Из ПоследниеИзменения Цикл
			Если ТипЗнч(ЧастьИзменений) = Тип("ФиксированныйМассив") Тогда
				Для каждого ОбъектМетаданных Из ЧастьИзменений Цикл
					Если ОбъектыМетаданных.Найти(ОбъектМетаданных) = Неопределено Тогда
						ОбъектыМетаданных.Добавить(ОбъектМетаданных);
					КонецЕсли;
				КонецЦикла;
			Иначе
				ОбъектыМетаданных = Неопределено;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		ОбновитьДанныеРегистра(, ОбъектыМетаданных);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет данные регистра при изменении состава ролей профилей и
// изменении профилей у групп доступа.
// 
// Параметры:
//  ГруппыДоступа - СправочникСсылка.ГруппыДоступа.
//                - Массив значений указанного выше типа.
//                - Неопределено - без отбора.
//
//  Таблицы       - СправочникСсылка.ИдентификаторыОбъектовМетаданных.
//                - Массив значений указанного выше типа.
//                - Неопределено - без отбора.
//
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(ГруппыДоступа = Неопределено,
                                 Таблицы       = Неопределено,
                                 ЕстьИзменения = Неопределено) Экспорт
	
	Если ТипЗнч(Таблицы) = Тип("Массив") Или ТипЗнч(Таблицы) = Тип("ФиксированныйМассив") Тогда
		КоличествоЗаписей = Таблицы.Количество();
		Если КоличествоЗаписей = 0 Тогда
			Возврат;
		ИначеЕсли КоличествоЗаписей > 500 Тогда
			Таблицы = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если Справочники.ВерсииРасширений.РасширенияИзмененыДинамически() Тогда
		ВызватьИсключение НСтр("ru = 'Расширения конфигурации обновлены, требуется перезапустить сеанс.'");
	КонецЕсли;
	
	РегистрыСведений.ПраваРолей.ПроверитьДанныеРегистра();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗапросПустыхЗаписей = Новый Запрос;
	ЗапросПустыхЗаписей.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	РегистрСведений.ТаблицыГруппДоступа КАК ТаблицыГруппДоступа
	|ГДЕ
	|	ТаблицыГруппДоступа.Таблица = ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	РегистрСведений.ТаблицыГруппДоступа КАК ТаблицыГруппДоступа
	|ГДЕ
	|	ТаблицыГруппДоступа.ГруппаДоступа = ЗНАЧЕНИЕ(Справочник.ГруппыДоступа.ПустаяСсылка)";
	
	ТекстЗапросовВременныхТаблиц =
	"ВЫБРАТЬ
	|	ПраваРолейРасширений.ОбъектМетаданных КАК ОбъектМетаданных,
	|	ПраваРолейРасширений.Роль КАК Роль,
	|	ПраваРолейРасширений.Добавление КАК Добавление,
	|	ПраваРолейРасширений.Изменение КАК Изменение,
	|	ПраваРолейРасширений.ЧтениеБезОграничения КАК ЧтениеБезОграничения,
	|	ПраваРолейРасширений.ДобавлениеБезОграничения КАК ДобавлениеБезОграничения,
	|	ПраваРолейРасширений.ИзменениеБезОграничения КАК ИзменениеБезОграничения,
	|	ПраваРолейРасширений.Просмотр КАК Просмотр,
	|	ПраваРолейРасширений.ИнтерактивноеДобавление КАК ИнтерактивноеДобавление,
	|	ПраваРолейРасширений.Редактирование КАК Редактирование,
	|	ПраваРолейРасширений.ВидИзмененияСтроки КАК ВидИзмененияСтроки
	|ПОМЕСТИТЬ ПраваРолейРасширений
	|ИЗ
	|	&ПраваРолейРасширений КАК ПраваРолейРасширений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПраваРолейРасширений.ОбъектМетаданных КАК ОбъектМетаданных,
	|	ПраваРолейРасширений.Роль КАК Роль,
	|	ПраваРолейРасширений.Добавление КАК Добавление,
	|	ПраваРолейРасширений.Изменение КАК Изменение,
	|	ПраваРолейРасширений.ЧтениеБезОграничения КАК ЧтениеБезОграничения,
	|	ПраваРолейРасширений.ДобавлениеБезОграничения КАК ДобавлениеБезОграничения,
	|	ПраваРолейРасширений.ИзменениеБезОграничения КАК ИзменениеБезОграничения,
	|	ПраваРолейРасширений.Просмотр КАК Просмотр,
	|	ПраваРолейРасширений.ИнтерактивноеДобавление КАК ИнтерактивноеДобавление,
	|	ПраваРолейРасширений.Редактирование КАК Редактирование
	|ПОМЕСТИТЬ ПраваРолей
	|ИЗ
	|	ПраваРолейРасширений КАК ПраваРолейРасширений
	|ГДЕ
	|	ПраваРолейРасширений.ВидИзмененияСтроки = 1
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПраваРолей.ОбъектМетаданных,
	|	ПраваРолей.Роль,
	|	ПраваРолей.Добавление,
	|	ПраваРолей.Изменение,
	|	ПраваРолей.ЧтениеБезОграничения,
	|	ПраваРолей.ДобавлениеБезОграничения,
	|	ПраваРолей.ИзменениеБезОграничения,
	|	ПраваРолей.Просмотр,
	|	ПраваРолей.ИнтерактивноеДобавление,
	|	ПраваРолей.Редактирование
	|ИЗ
	|	РегистрСведений.ПраваРолей КАК ПраваРолей
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПраваРолейРасширений КАК ПраваРолейРасширений
	|		ПО ПраваРолей.ОбъектМетаданных = ПраваРолейРасширений.ОбъектМетаданных
	|			И ПраваРолей.Роль = ПраваРолейРасширений.Роль
	|ГДЕ
	|	ПраваРолейРасширений.ОбъектМетаданных ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГруппыДоступа.Профиль КАК Профиль,
	|	ПраваРолей.ОбъектМетаданных КАК Таблица,
	|	ПраваРолей.ОбъектМетаданных.ЗначениеПустойСсылки КАК ТипТаблицы,
	|	МАКСИМУМ(ПраваРолей.Изменение) КАК Изменение
	|ПОМЕСТИТЬ ТаблицыПрофилей
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа.Роли КАК РолиПрофиля
	|		ПО ГруппыДоступа.Профиль = РолиПрофиля.Ссылка
	|			И (&УсловиеОтбораГруппДоступа1)
	|			И (НЕ ГруппыДоступа.ПометкаУдаления)
	|			И (НЕ РолиПрофиля.Ссылка.ПометкаУдаления)
	|			И (РолиПрофиля.Ссылка <> ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.Администратор))
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПраваРолей КАК ПраваРолей
	|		ПО (&УсловиеОтбораТаблиц1)
	|			И (ПраваРолей.Роль = РолиПрофиля.Роль)
	|			И (НЕ ПраваРолей.Роль.ПометкаУдаления)
	|			И (НЕ ПраваРолей.ОбъектМетаданных.ПометкаУдаления)
	|
	|СГРУППИРОВАТЬ ПО
	|	ГруппыДоступа.Профиль,
	|	ПраваРолей.ОбъектМетаданных,
	|	ПраваРолей.ОбъектМетаданных.ЗначениеПустойСсылки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПраваРолей.ОбъектМетаданных
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицыПрофилей.Таблица КАК Таблица,
	|	ГруппыДоступа.Ссылка КАК ГруппаДоступа,
	|	ТаблицыПрофилей.Изменение КАК Изменение,
	|	ТаблицыПрофилей.ТипТаблицы КАК ТипТаблицы
	|ПОМЕСТИТЬ НовыеДанные
	|ИЗ
	|	ТаблицыПрофилей КАК ТаблицыПрофилей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ПО (&УсловиеОтбораГруппДоступа1)
	|			И (ГруппыДоступа.Профиль = ТаблицыПрофилей.Профиль)
	|			И (НЕ ГруппыДоступа.ПометкаУдаления)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТаблицыПрофилей.Таблица,
	|	ГруппыДоступа.Ссылка";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НовыеДанные.Таблица,
	|	НовыеДанные.ГруппаДоступа,
	|	НовыеДанные.Изменение,
	|	НовыеДанные.ТипТаблицы,
	|	&ПодстановкаПоляВидИзмененияСтроки
	|ИЗ
	|	НовыеДанные КАК НовыеДанные";
	
	// Подготовка выбираемых полей с необязательным отбором.
	Поля = Новый Массив; 
	Поля.Добавить(Новый Структура("Таблица",       "&УсловиеОтбораТаблиц2"));
	Поля.Добавить(Новый Структура("ГруппаДоступа", "&УсловиеОтбораГруппДоступа2"));
	Поля.Добавить(Новый Структура("Изменение"));
	Поля.Добавить(Новый Структура("ТипТаблицы"));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПраваРолейРасширений", УправлениеДоступомСлужебный.ПраваРолейРасширений());
	Запрос.Текст = УправлениеДоступомСлужебный.ТекстЗапросаВыбораИзменений(
		ТекстЗапроса, Поля, "РегистрСведений.ТаблицыГруппДоступа", ТекстЗапросовВременныхТаблиц);
	
	УправлениеДоступомСлужебный.УстановитьУсловиеОтбораВЗапросе(Запрос, Таблицы, "Таблицы",
		"&УсловиеОтбораТаблиц1:ПраваРолей.ОбъектМетаданных
		|&УсловиеОтбораТаблиц2:СтарыеДанные.Таблица");
	
	УправлениеДоступомСлужебный.УстановитьУсловиеОтбораВЗапросе(Запрос, ГруппыДоступа, "ГруппыДоступа",
		"&УсловиеОтбораГруппДоступа1:ГруппыДоступа.Ссылка
		|&УсловиеОтбораГруппДоступа2:СтарыеДанные.ГруппаДоступа");
		
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ТаблицыГруппДоступа");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Результаты = ЗапросПустыхЗаписей.ВыполнитьПакет();
		Если Не Результаты[0].Пустой() Тогда
			СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Таблица.Установить(Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
			НаборЗаписей.Записать();
			ЕстьИзменения = Истина;
		КонецЕсли;
		Если Не Результаты[1].Пустой() Тогда
			СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ГруппаДоступа.Установить(Справочники.ГруппыДоступа.ПустаяСсылка());
			НаборЗаписей.Записать();
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если ГруппыДоступа <> Неопределено
		   И Таблицы        = Неопределено Тогда
			
			ИзмеренияОтбора = "ГруппаДоступа";
		Иначе
			ИзмеренияОтбора = Неопределено;
		КонецЕсли;
		
		Данные = Новый Структура;
		Данные.Вставить("МенеджерРегистра",      РегистрыСведений.ТаблицыГруппДоступа);
		Данные.Вставить("ИзмененияСоставаСтрок", Запрос.Выполнить().Выгрузить());
		Данные.Вставить("ИзмеренияОтбора",       ИзмеренияОтбора);
		
		ЕстьТекущиеИзменения = Ложь;
		УправлениеДоступомСлужебный.ОбновитьРегистрСведений(Данные, ЕстьТекущиеИзменения);
		Если ЕстьТекущиеИзменения Тогда
			СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли