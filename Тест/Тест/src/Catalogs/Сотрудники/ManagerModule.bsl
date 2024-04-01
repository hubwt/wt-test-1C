#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры


Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьРеквизиты(Ссылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.Ссылка,
	|	Сотрудники.Наименование,
	|	Сотрудники.Фамилия,
	|	Сотрудники.Имя,
	|	Сотрудники.Отчество,
	|	Сотрудники.ДатаРождения,
	|	Сотрудники.ПаспортСерияНомер,
	|	Сотрудники.ПаспортКемВыдан,
	|	Сотрудники.ПаспортДатаВыдачи,
	|	Сотрудники.ПаспортКодПодразделения
	|ПОМЕСТИТЬ втСотрудники
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудники.Фамилия,
	|	Сотрудники.Имя,
	|	Сотрудники.Отчество,
	|	Сотрудники.Наименование,
	|	Сотрудники.ПаспортСерияНомер,
	|	Сотрудники.ПаспортКемВыдан,
	|	Сотрудники.ПаспортДатаВыдачи,
	|	Сотрудники.ПаспортКодПодразделения,
	|	КИФактическийАдрес.Представление КАК ФактическийАдрес,
	|	КИТелефон.Представление КАК Телефоны,
	|	КИEmail.Представление КАК Email
	|ИЗ
	|	втСотрудники КАК Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники.КонтактнаяИнформация КАК КИФактическийАдрес
	|		ПО КИФактическийАдрес.Ссылка = Сотрудники.Ссылка
	|		И КИФактическийАдрес.Вид = &ВидКИ1
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники.КонтактнаяИнформация КАК КИТелефон
	|		ПО КИТелефон.Ссылка = Сотрудники.Ссылка
	|		И КИТелефон.Вид = &ВидКИ2
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники.КонтактнаяИнформация КАК КИEmail
	|		ПО КИEmail.Ссылка = Сотрудники.Ссылка
	|		И КИEmail.Вид = &ВидКИ3";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидКИ1", Справочники.ВидыКонтактнойИнформации.АдресСотрудникаФактический);
	Запрос.УстановитьПараметр("ВидКИ2", Справочники.ВидыКонтактнойИнформации.ТелефонСотрудникаЛичный);
	Запрос.УстановитьПараметр("ВидКИ3", Справочники.ВидыКонтактнойИнформации.EmailСотрудника);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат новый Структура();
	КонецЕсли;
	
	
	Результат = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(РезультатЗапроса.Выгрузить()[0]);
	
	ФИО = Новый Массив();
	РеквизитыФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("Фамилия,Имя,Отчество");
	Для каждого Реквизит Из РеквизитыФИО Цикл
		Если ЗначениеЗаполнено(Результат[Реквизит]) Тогда
			ФИО.Добавить(Результат[Реквизит]);
		КонецЕсли;
	КонецЦикла;
	
	ФИО = СтрСоединить(ФИО, " ");
	
	Результат.Вставить("НаименованиеДляПечатныхФорм", ФИО);
	Результат.Вставить("НаименованиеПолное", ФИО);
	Результат.Вставить("ФамилияИнициалы", ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ФИО));
	
	Результат.Вставить("Паспорт", 
		СтрШаблон("Паспорт %1 выдан %2 г. %3", 
			Результат.ПаспортСерияНомер,
			Формат(Результат.ПаспортДатаВыдачи, "ДЛФ=D;"),
			Результат.ПаспортКемВыдан
		)
	);
	
	
	Возврат Результат;
		
КонецФункции


#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли