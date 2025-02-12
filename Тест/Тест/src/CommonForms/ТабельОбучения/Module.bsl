
&НаКлиенте
Процедура Таблица1ПриАктивизацииСтроки(Элемент)
		
	///+ГомзМА 05.05.2023
	Если Элементы.Таблица1.ТекущиеДанные <> Неопределено Тогда
		ТекДанные = Элементы.Таблица1.ТекущиеДанные;
		Если Элементы.Таблица1.ТекущиеДанные.РодительскаяГруппировкаСтроки <> Неопределено Тогда
			ТаблицаТЧ.Параметры.УстановитьЗначениеПараметра("Ссылка", ТекДанные.Документ);
		Иначе
			ТаблицаТЧ.Параметры.УстановитьЗначениеПараметра("Ссылка", ПредопределенноеЗначение("Документ.ЭкзаменационныеЛисты.ПустаяСсылка"));
		КонецЕсли;
	КонецЕсли;
	///-ГомзМА 05.05.2023
	
КонецПроцедуры

&НаКлиенте
Процедура Таблица1Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	///+ГомзМА 05.05.2023
	ТекСтрока = Элементы.Таблица1.ТекущиеДанные;
	Если Поле = Элементы.Таблица1Ссылка Тогда
		
		СсылкаДляОткрытия    = ТекСтрока.Документ;
		ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
		
		ФормаДокумента 		 = ПолучитьФорму("Документ.ЭкзаменационныеЛисты.ФормаОбъекта", ПараметрыФормы);
		ФормаДокумента.Открыть();
	КонецЕсли;
	///+ГомзМА 05.05.2023
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТЧВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	///+ГомзМА 05.05.2023
	ТекСтрока = Элементы.ТаблицаТЧ.ТекущиеДанные;
	Если Поле = Элементы.ТаблицаТЧДатаЭкзамена Тогда
   		Оповещение = Новый ОписаниеОповещения("ПослеВводаДаты",  ЭтотОбъект, ТекСтрока);
    	ПоказатьВводДаты(Оповещение, , "Введите дату экзамена:", ЧастиДаты.ДатаВремя);
	КонецЕсли;
	///-ГомзМА 05.05.2023
	
КонецПроцедуры

&НаСервере
Процедура ПослеВводаДаты(ДатаВыгрузки, Параметры) Экспорт

	///+ГомзМА 05.05.2023
	Если Не ДатаВыгрузки = Неопределено Тогда
		ДокОбъект =	Параметры.Ссылка.ПолучитьОбъект();
       	//Сообщить(ДатаВыгрузки);
    КонецЕсли;
	///-ГомзМА 05.05.2023
	
КонецПроцедуры

&НаСервере
Функция ПечатьЭкзаменационногоЛистаНаСервере()
	
	///+ГомзМА 02.05.2023 
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.ПеремещениеТМЦВорктрак.ПолучитьМакет("АктПеремещения");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЭкзаменационныеЛистыРезультаты.Тема КАК Тема,
	|	ЭкзаменационныеЛистыРезультаты.Оценка КАК Оценка,
	|	ЭкзаменационныеЛистыРезультаты.Ссылка.Учащийся КАК Учащийся,
	|	ЭкзаменационныеЛистыРезультаты.Тема.Владелец КАК Отдел,
	|	ЭкзаменационныеЛистыРезультаты.Ссылка.Ссылка КАК Ссылка,
	|	ЭкзаменационныеЛистыРезультаты.ДатаОценки КАК ДатаОценки,
	|	ЭкзаменационныеЛистыРезультаты.ДатаЭкзамена КАК ДатаЭкзамена
	|ИЗ
	|	Документ.ЭкзаменационныеЛисты.Результаты КАК ЭкзаменационныеЛистыРезультаты
	|ГДЕ
	|	ЭкзаменационныеЛистыРезультаты.Ссылка.Ссылка = &Ссылка";
	
	//Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ВыборкаЗапрос = Запрос.Выполнить().Выбрать();
		
	ОбластьШапка  = Макет.ПолучитьОбласть("ОбластьШапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("ОбластьСтрока");
	ОбластьПодвал = Макет.ПолучитьОбласть("ОбластьПодвал");
	ТабДок.Очистить();
	
	ВыборкаЗапрос.Следующий();
	
	ОбластьШапка.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьШапка, ВыборкаЗапрос.Уровень());
	
	ОбластьСтрока.Параметры.Заполнить(ВыборкаЗапрос);
	ТабДок.Вывести(ОбластьСтрока, ВыборкаЗапрос.Уровень());
		
	Пока ВыборкаЗапрос.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(ВыборкаЗапрос);
		ТабДок.Вывести(ОбластьСтрока, ВыборкаЗапрос.Уровень());
	КонецЦикла;
	
	ТабДок.Вывести(ОбластьПодвал);
	
	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	
	Возврат ТабДок;
	///-ГомзМА 02.05.2023
	
КонецФункции

&НаКлиенте
Процедура ПечатьЭкзаменационногоЛиста(Команда)
	
	///+ГомзМА 29.05.2023 
	ТабДок = ПечатьЭкзаменационногоЛистаНаСервере();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("АктПеремещения");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "АктПеремещения";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, Неопределено, ЭтаФорма);
	///-ГомзМА 29.05.2023
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	////для динамического списка
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ ПЕРВЫЕ 1
	//	|	ДолжностиСотрудниковСрезПоследних.Сотрудник.Пользователь КАК СотрудникПользователь,
	//	|	ДолжностиСотрудниковСрезПоследних.Сотрудник.Пользователь.Подразделение КАК СотрудникПользовательПодразделение,
	//	|	ДолжностиСотрудниковСрезПоследних.Регистратор.Город КАК РегистраторГород,
	//	|	ДолжностиСотрудниковСрезПоследних.Регистратор КАК Регистратор
	//	|ИЗ
	//	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних(, ) КАК ДолжностиСотрудниковСрезПоследних
	//	|ГДЕ
	//	|	НЕ ДолжностиСотрудниковСрезПоследних.Сотрудник.Пользователь.Недействителен
	//	|	И ДолжностиСотрудниковСрезПоследних.Регистратор ССЫЛКА Документ.КадровыйПриказ
	//	|	И ДолжностиСотрудниковСрезПоследних.Сотрудник = &Сотрудник
	//	|
	//	|УПОРЯДОЧИТЬ ПО
	//	|	ДолжностиСотрудниковСрезПоследних.Регистратор.Дата УБЫВ";
	//
	//Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	//
	//РезультатЗапроса = Запрос.Выполнить().Выбрать();
	

КонецПроцедуры


