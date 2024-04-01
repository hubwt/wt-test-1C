#Область Склонения

Функция НовыйТаблицаСоответствияПадежей() Экспорт

	СклоненияТЗ = Новый ТаблицаЗначений();
	СклоненияТЗ.Колонки.Добавить("Слово");
	СклоненияТЗ.Колонки.Добавить("Падеж");
	СклоненияТЗ.Колонки.Добавить("КоличествоСимволовОкончания");
	СклоненияТЗ.Колонки.Добавить("Окончание");
	
	Возврат СклоненияТЗ;
КонецФункции // НовыйТаблицаСоответствияПадежей()

Процедура ЗаполнитьСклонение(СклоненияТЗ, Слово, Падеж, КоличествоСимволовОкончания, Окончание)

	
	НоваяСтрока = СклоненияТЗ.Добавить();
	НоваяСтрока.Слово = Слово;
	НоваяСтрока.Падеж = Падеж;
	НоваяСтрока.КоличествоСимволовОкончания = КоличествоСимволовОкончания;
	НоваяСтрока.Окончание = Окончание;
	
КонецПроцедуры // ЗаполнитьСклонение()


Процедура ЗаполнитьСклонения(Склонения) Экспорт
	
	// Р.П. - в рамках договорА
	ЗаполнитьСклонение(Склонения, "договор",			2, 0, "а");	
	ЗаполнитьСклонение(Склонения, "государственный",	2, 2, "ого");	
	ЗаполнитьСклонение(Склонения, "контракт",			2, 0, "а");	
	ЗаполнитьСклонение(Склонения, "счет",				2, 0, "а");	
	ЗаполнитьСклонение(Склонения, "спецификация",		2, 1, "и");	
	ЗаполнитьСклонение(Склонения, "дополнительное",		2, 1, "го");	
	ЗаполнитьСклонение(Склонения, "соглашение",			2, 1, "я");	
	// должности
	ЗаполнитьСклонение(Склонения, "генеральный",		2, 2, "ого");	
	ЗаполнитьСклонение(Склонения, "коммерческий",		2, 2, "ого");	
	ЗаполнитьСклонение(Склонения, "директор",			2, 0, "а");	
	
	// Д.П. - по договору
	ЗаполнитьСклонение(Склонения, "договор", 3, 0, "у");	
	ЗаполнитьСклонение(Склонения, "государственный", 3, 2, "ому");	
	ЗаполнитьСклонение(Склонения, "контракт", 3, 0, "у");	
	ЗаполнитьСклонение(Склонения, "счет", 3, 0, "у");	
	ЗаполнитьСклонение(Склонения, "спецификация", 3, 1, "и");	
	ЗаполнитьСклонение(Склонения, "дополнительное", 3, 1, "му");	
	ЗаполнитьСклонение(Склонения, "соглашение", 3, 1, "ю");	
	// должности
	ЗаполнитьСклонение(Склонения, "генеральный",		3, 2, "ому");	
	ЗаполнитьСклонение(Склонения, "коммерческий",		3, 2, "ому");	
	ЗаполнитьСклонение(Склонения, "директор",			3, 0, "у");	

		// Т.П. - с договором 5
	ЗаполнитьСклонение(Склонения, "к договор", 5, 0, "у");	
	ЗаполнитьСклонение(Склонения, "договор", 5, 0, "ом");	
	ЗаполнитьСклонение(Склонения, "государственный", 5, 1, "м");	
	ЗаполнитьСклонение(Склонения, "контракт", 5, 0, "ом");	
	ЗаполнитьСклонение(Склонения, "счет", 5, 0, "ом");	
	ЗаполнитьСклонение(Склонения, "спецификация", 5, 1, "ей");	
	ЗаполнитьСклонение(Склонения, "дополнительное", 5, 2, "ым");	
	ЗаполнитьСклонение(Склонения, "соглашение", 5, 0, "м");	
	// должности
	ЗаполнитьСклонение(Склонения, "генеральный",		5, 1, "мм");	
	ЗаполнитьСклонение(Склонения, "коммерческий",		5, 1, "м");	
	ЗаполнитьСклонение(Склонения, "директор",			5, 0, "ом");	
	
КонецПроцедуры // ЗаполнитьПадежи()

Функция Просклонять(Знач Слово, Падеж, Склонения = Неопределено) Экспорт
	
	Если Склонения = Неопределено Тогда
		Склонения = НовыйТаблицаСоответствияПадежей();
		Если Склонения.Количество() = 0 Тогда
			ЗаполнитьСклонения(Склонения);
		КонецЕсли;
	КонецЕсли;
	
	СклоненияВыборка = Склонения.НайтиСтроки(Новый Структура("Падеж", Падеж));	
	СловоШаблон = ВРЕГ(Слово);
	Для каждого Склонение Из СклоненияВыборка Цикл
		
		ПодстрокаШаблон = ВРЕГ(Склонение.Слово);
		Поз = СтрНайти(СловоШаблон, ПодстрокаШаблон);
		Пока Поз <> 0 Цикл
			
			// проверка целого слова
			Если Поз + СтрДлина(ПодстрокаШаблон) = СтрДлина(СловоШаблон) 
				ИЛИ СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола(Сред(СловоШаблон, Поз + СтрДлина(ПодстрокаШаблон), 1))) Тогда
			
			НайденноеСлово = Сред(Слово, Поз, СтрДлина(ПодстрокаШаблон));
			СловоВПадеже = ПолучитьСклонение(НайденноеСлово, Склонение);
			
			Слово = Лев(Слово, Поз - 1) + СловоВПадеже + Сред(Слово, Поз + СтрДлина(ПодстрокаШаблон));
			СловоШаблон = ВРЕГ(Слово);
			
			// Смещаем позицию на добавленные символы
			Поз = Поз + СтрДлина(СловоВПадеже) - СтрДлина(ПодстрокаШаблон);
			КонецЕсли;
		
			Поз = СтрНайти(СловоШаблон, ПодстрокаШаблон, , Поз + 1);
			
		КонецЦикла;
	
	КонецЦикла;
	
	Возврат Слово;
	
КонецФункции // Просклонять()

Функция ПолучитьСклонение(Слово, ПараметрыСклонения)

	Возврат ?(ПараметрыСклонения.КоличествоСимволовОкончания = 0, 
		Слово,
		Лев(Слово, СтрДлина(Слово) - ПараметрыСклонения.КоличествоСимволовОкончания)) + ПараметрыСклонения.Окончание;
	

КонецФункции // ПолучитьСклонение()
	
#КонецОбласти

#Область Наименования
Функция ПолучитьТаблицуСокращений() Экспорт
	
	Замены = Новый ТаблицаЗначений();
	Замены.Колонки.Добавить("Полное");
	Замены.Колонки.Добавить("Сокращенное");
	
	НоваяСтрока = Замены.Добавить();
	НоваяСтрока.Полное = "Индивидуальный предприниматель";
	НоваяСтрока.Сокращенное = "ИП";
	
	НоваяСтрока = Замены.Добавить();
	НоваяСтрока.Полное = "Общество с ограниченной ответственностью";
	НоваяСтрока.Сокращенное = "ООО";
	
	Возврат Замены;
	
КонецФункции
	
#КонецОбласти


Функция ПрефиксИБ() Экспорт

	Возврат Константы.дт_ПрефиксИБ.Получить();

КонецФункции // ПрефиксИБ()

#Область Служебные
// Возвращает структуру реквизитов справочника.
//
// Параметры:
//		ИмяСправочника - Строка - имя справочника как оно задано в метаданных
// Возвращаемое значение:
//		Структура - стандартные и обычные реквизиты справочника.
//
Функция РеквизитыСправочника(ИмяСправочника) Экспорт
	
	СтруктураРеквизитов   = Новый Структура;
	МетаданныеСправочника = Метаданные.Справочники[ИмяСправочника];
	
	Для Каждого Реквизит Из МетаданныеСправочника.СтандартныеРеквизиты Цикл
		СтруктураРеквизитов.Вставить(Реквизит.Имя, Реквизит.Синоним);
	КонецЦикла;
	
	Для Каждого Реквизит Из МетаданныеСправочника.Реквизиты Цикл
		СтруктураРеквизитов.Вставить(Реквизит.Имя, Реквизит.Синоним);
	КонецЦикла;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

	
#КонецОбласти