
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	///+ГомзМА 11.05.2023
	ТМЦ.Параметры.УстановитьЗначениеПараметра("МестоХранения", 			Объект.Ссылка);
	ТМЦ.Параметры.УстановитьЗначениеПараметра("Дата", 					ТекущаяДатаСеанса());
	
	//Если Объект.ВидСписания = Перечисления.ВидыСписания.МусорВУтиль Тогда
	//	Расходники.Параметры.УстановитьЗначениеПараметра("СписаниеВРасход", 		Объект.Ссылка);
	//ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.Сотруднику Тогда
	//	Расходники.Параметры.УстановитьЗначениеПараметра("СписаниеНаСотрудника", 	Объект.Ссылка);
	//ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.ВОтдел Тогда
	//	Расходники.Параметры.УстановитьЗначениеПараметра("СписаниеНаОтдел", 		Объект.Ссылка);
	//КонецЕсли;
	
	Расходники.Параметры.УстановитьЗначениеПараметра("СписаниеВРасход", 	 Объект.Ссылка);
	Расходники.Параметры.УстановитьЗначениеПараметра("СписаниеНаСотрудника", Объект.Ссылка);
	Расходники.Параметры.УстановитьЗначениеПараметра("СписаниеНаОтдел", 	 Объект.Ссылка);
	
	//Если Объект.ВидСписания = Перечисления.ВидыСписания.МусорВУтиль Тогда
	//	Расходники.Параметры.УстановитьЗначениеПараметра("СписаниеВРасход", 	 Объект.Ссылка);
	//ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.Сотруднику Тогда
	//	Расходники.Параметры.УстановитьЗначениеПараметра("СписаниеНаСотрудника", Объект.Ссылка);
	//ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.ВОтдел Тогда
	//	Расходники.Параметры.УстановитьЗначениеПараметра("СписаниеНаОтдел", 	 Объект.Ссылка);
	//КонецЕсли;
	///-ГомзМА 11.05.2023
	
КонецПроцедуры


#КонецОбласти 

#Область ОбработчикиКомандФормы
	
&НаКлиенте
Процедура ПечатьТМЦ(Команда)
	
	///+ГомзМА 11.05.2023 
	ТабДок = ПечатьТМЦНаСервере();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ПечатьТМЦ");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров = 1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "ПечатьТМЦ";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, Неопределено, ЭтаФорма);
	///-ГомзМА 11.05.2023
	
КонецПроцедуры


&НаКлиенте
Процедура ПечатьРасходники(Команда)
	
	
	///+ГомзМА 11.05.2023 
	ТабДок = ПечатьРасходникиНаСервере();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ПечатьРасходники");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров = 1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "ПечатьРасходники";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, Неопределено, ЭтаФорма);
	///-ГомзМА 11.05.2023
	
КонецПроцедуры


#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПечатьТМЦНаСервере()
	
	///+ГомзМА 11.05.2023 
	ТабДок = Новый ТабличныйДокумент;
	Макет = Справочники.МестаХраненияТМЦ.ПолучитьМакет("ПечатьТМЦ");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнвентарныеНомера.Наименование КАК Наименование,
	|	ИнвентарныеНомера.СерийныйНомер КАК СерийныйНомер,
	|	ИнвентарныеНомера.Стоимость КАК Стоимость,
	|	ИнвентарныеНомера.ДокументПоступления КАК ДокументПоступления,
	|	ИнвентарныеНомера.Владелец КАК Номенклатура,
	|	ДвижениеТМЦСкладСнабжениеОстатки.МестоХранения КАК МестоХранения,
	|	ДвижениеТМЦСкладСнабжениеОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	Справочник.ИнвентарныеНомера КАК ИнвентарныеНомера
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДвижениеТМЦСкладСнабжение.Остатки(&Дата, ) КАК ДвижениеТМЦСкладСнабжениеОстатки
	|		ПО ИнвентарныеНомера.Ссылка = ДвижениеТМЦСкладСнабжениеОстатки.ИнвентарныйНомер
	|			И ИнвентарныеНомера.Владелец = ДвижениеТМЦСкладСнабжениеОстатки.ТМЦ
	|ГДЕ
	|	ДвижениеТМЦСкладСнабжениеОстатки.МестоХранения = &МестоХранения
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ИнвентарныеНомера.Наименование,
	|	ИнвентарныеНомера.СерийныйНомер,
	|	ИнвентарныеНомера.Стоимость,
	|	ИнвентарныеНомера.ДокументПоступления,
	|	ИнвентарныеНомера.Владелец,
	|	ДвижениеТМЦВорктракОстатки.МестоХранения,
	|	ДвижениеТМЦВорктракОстатки.КоличествоОстаток
	|ИЗ
	|	Справочник.ИнвентарныеНомера КАК ИнвентарныеНомера
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДвижениеТМЦВорктрак.Остатки КАК ДвижениеТМЦВорктракОстатки
	|		ПО ИнвентарныеНомера.Ссылка = ДвижениеТМЦВорктракОстатки.ИнвентарныйНомер
	|			И ИнвентарныеНомера.Владелец = ДвижениеТМЦВорктракОстатки.ТМЦ
	|ГДЕ
	|	ДвижениеТМЦВорктракОстатки.МестоХранения = &МестоХранения";
	
	Запрос.УстановитьПараметр("Дата", 			 ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("МестоХранения",   Объект.Ссылка);
	
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


&НаСервере
Функция ПечатьРасходникиНаСервере()

		///+ГомзМА 11.05.2023 
	ТабДок = Новый ТабличныйДокумент;
	Макет = Справочники.МестаХраненияТМЦ.ПолучитьМакет("ПечатьРасходники");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписаниеТМЦСкладСнабжениеСписокТМЦ.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	СписаниеТМЦСкладСнабжениеСписокТМЦ.ТМЦ КАК ТМЦ,
	|	СписаниеТМЦСкладСнабжениеСписокТМЦ.СерийныйНомер КАК СерийныйНомер,
	|	СписаниеТМЦСкладСнабжениеСписокТМЦ.Количество КАК Количество,
	|	СписаниеТМЦСкладСнабжениеСписокТМЦ.Сумма КАК Сумма,
	|	СписаниеТМЦСкладСнабжениеСписокТМЦ.Ссылка КАК Документ,
	|	СписаниеТМЦСкладСнабжениеСписокТМЦ.Цена КАК Цена
	|ИЗ
	|	Документ.СписаниеТМЦСкладСнабжение.СписокТМЦ КАК СписаниеТМЦСкладСнабжениеСписокТМЦ
	|{ГДЕ
	|	(СписаниеТМЦСкладСнабжениеСписокТМЦ.Ссылка.СписаниеВРасход = &СписаниеВРасход
	|			ИЛИ СписаниеТМЦСкладСнабжениеСписокТМЦ.Ссылка.СписаниеНаСотрудника = &СписаниеНаСотрудника
	|			ИЛИ СписаниеТМЦСкладСнабжениеСписокТМЦ.Ссылка.СписаниеНаОтдел = &СписаниеНаОтдел) КАК Поле2}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СписаниеТМЦВорктракСписокТМЦ.ИнвентарныйНомер,
	|	СписаниеТМЦВорктракСписокТМЦ.ТМЦ,
	|	СписаниеТМЦВорктракСписокТМЦ.СерийныйНомер,
	|	СписаниеТМЦВорктракСписокТМЦ.Количество,
	|	СписаниеТМЦВорктракСписокТМЦ.Сумма,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка,
	|	СписаниеТМЦВорктракСписокТМЦ.Цена
	|ИЗ
	|	Документ.СписаниеТМЦВорктрак.СписокТМЦ КАК СписаниеТМЦВорктракСписокТМЦ
	|{ГДЕ
	|	(СписаниеТМЦВорктракСписокТМЦ.Ссылка.СписаниеВРасход = &СписаниеВРасход
	|			ИЛИ СписаниеТМЦВорктракСписокТМЦ.Ссылка.СписаниеНаСотрудника = &СписаниеНаСотрудника
	|			ИЛИ СписаниеТМЦВорктракСписокТМЦ.Ссылка.СписаниеНаОтдел = &СписаниеНаОтдел) КАК Поле2}";
	
	Запрос.УстановитьПараметр("Дата", 			 		ТекущаяДатаСеанса());

	//Если Объект.ВидСписания = Перечисления.ВидыСписания.МусорВУтиль Тогда
	//	Запрос.УстановитьПараметр("СписаниеВРасход", 		Объект.Ссылка);
	//ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.Сотруднику Тогда
	//	Запрос.УстановитьПараметр("СписаниеНаСотрудника", 	Объект.Ссылка);
	//ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.ВОтдел Тогда
	//	Запрос.УстановитьПараметр("СписаниеНаОтдел", 		Объект.Ссылка);
	//КонецЕсли;
	
	Запрос.УстановитьПараметр("СписаниеВРасход", 		Объект.Ссылка);
	Запрос.УстановитьПараметр("СписаниеНаСотрудника", 	Объект.Ссылка);
	Запрос.УстановитьПараметр("СписаниеНаОтдел", 		Объект.Ссылка);
	
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

КонецФункции // ПечатьРасходникиНаСервере()


#КонецОбласти




