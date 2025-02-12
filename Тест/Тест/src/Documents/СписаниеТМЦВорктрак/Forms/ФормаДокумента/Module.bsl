
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьИДоступностьЭлементов();
КонецПроцедуры


&НаКлиенте
Процедура СписокТМЦЦенаПриИзменении(Элемент)
		ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
КонецПроцедуры


&НаКлиенте
Процедура СписокТМЦКоличествоПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("СписокТМЦ", "Количество");
КонецПроцедуры


&НаКлиенте
Процедура ВидСписанияПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТМЦИнвентарныйНомерПриИзменении(Элемент)
	
	ТекСтрока = Элементы.СписокТМЦ.ТекущиеДанные;
	
	РаботаСДокументамиТМЦКлиент.УстановитьДанныеПоИнвентарномуНомеру(ТекСтрока);
	
	ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
	
		
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПечатьАктСписания(Команда)
	ПечатьАктСписанияНаСервере();
	
	///+ГомзМА 14.04.2023 
	ТабДок = ПечатьАктСписанияНаСервере();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("АктСписания");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "АктСписания";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм,Неопределено,ЭтаФорма);
	///-ГомзМА 14.04.2023
	
КонецПроцедуры


&НаКлиенте
Процедура ПечатьАктСписанияРасходников(Команда)
	
	///+ГомзМА 19.05.2023 
	ТабДок = ПечатьАктСписанияРасходниковНаСервере();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("АктСписанияРасходников");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "АктСписанияРасходников";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, Неопределено, ЭтаФорма);
	///-ГомзМА 19.05.2023
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаИзмененияСтроки(ИмяТабличнойЧасти, Поле = Неопределено, ДанныеСтроки = Неопределено)
	
	ТекДанные = ?(ДанныеСтроки = Неопределено, Элементы[ИмяТабличнойЧасти].ТекущиеДанные, ДанныеСтроки);
	
	Если Поле = "Сумма" Тогда
		Если ТекДанные.Количество <> 0 Тогда
			ТекДанные.Цена = ТекДанные.Сумма / ТекДанные.Количество;
		КонецЕсли;	
	Иначе	
		ТекДанные.Сумма = ТекДанные.Цена * ТекДанные.Количество;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаИзмененияСтроки()


&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()

	/////+ГомзМА 25.04.2023
	//Если Объект.ВидСписания = Перечисления.ВидыСписания.ВУтиль Тогда
	//	Элементы.СписокТМЦ.ПодчиненныеЭлементы.СписокТМЦСклад.Видимость = Ложь;
	//Иначе
	//	Элементы.СписокТМЦ.ПодчиненныеЭлементы.СписокТМЦСклад.Видимость = Истина;
	//КонецЕсли;
	/////-ГомзМА 25.04.2023
	
	///+ГомзМА 10.05.2023
	Если Объект.ВидСписания = Перечисления.ВидыСписания.ВЗаказНаряд Тогда
		Элементы.СписаниеВРасход.Видимость		= Ложь;
		Элементы.СписаниеВТМЦ.Видимость			= Ложь;
		Элементы.СписаниеВПродажу.Видимость		= Ложь;
		Элементы.СписаниеВЗаказНаряд.Видимость	= Истина;
		Элементы.СписаниеНаСотрудника.Видимость = Ложь;
		Элементы.СписаниеНаОтдел.Видимость		= Ложь;
		Элементы.Инициатор.Видимость 			= Истина;
		
		НазначитьПустыеСсылки();
	ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.ВОтдел Тогда
		Элементы.СписаниеВРасход.Видимость		= Ложь;
		Элементы.СписаниеВТМЦ.Видимость			= Ложь;
		Элементы.СписаниеВПродажу.Видимость		= Ложь;
		Элементы.СписаниеВЗаказНаряд.Видимость	= Ложь;
		Элементы.СписаниеНаСотрудника.Видимость = Ложь;
		Элементы.СписаниеНаОтдел.Видимость		= Истина;
		Элементы.Инициатор.Видимость 			= Ложь;
		
		НазначитьПустыеСсылки();
	ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.ВПродажу Тогда
		Элементы.СписаниеВРасход.Видимость		= Ложь;
		Элементы.СписаниеВТМЦ.Видимость			= Ложь;
		Элементы.СписаниеВПродажу.Видимость		= Истина;
		Элементы.СписаниеВЗаказНаряд.Видимость	= Ложь;
		Элементы.СписаниеНаСотрудника.Видимость = Ложь;
		Элементы.СписаниеНаОтдел.Видимость		= Ложь;
		Элементы.Инициатор.Видимость 			= Истина;
		
		НазначитьПустыеСсылки();
	ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.КомплектацияТМЦ Тогда
		Элементы.СписаниеВРасход.Видимость		= Ложь;
		Элементы.СписаниеВТМЦ.Видимость			= Истина;
		Элементы.СписаниеВПродажу.Видимость		= Ложь;
		Элементы.СписаниеВЗаказНаряд.Видимость	= Ложь;
		Элементы.СписаниеНаСотрудника.Видимость = Ложь;
		Элементы.СписаниеНаОтдел.Видимость		= Ложь;
		Элементы.Инициатор.Видимость 			= Ложь;
		
		НазначитьПустыеСсылки();
	ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.МусорВУтиль Тогда
		Элементы.СписаниеВРасход.Видимость		= Истина;
		Элементы.СписаниеВТМЦ.Видимость			= Ложь;
		Элементы.СписаниеВПродажу.Видимость		= Ложь;
		Элементы.СписаниеВЗаказНаряд.Видимость	= Ложь;
		Элементы.СписаниеНаСотрудника.Видимость = Ложь;
		Элементы.СписаниеНаОтдел.Видимость		= Ложь;
		Элементы.Инициатор.Видимость 			= Ложь;
		
		НазначитьПустыеСсылки();
	ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.Сотруднику Тогда
		Элементы.СписаниеВРасход.Видимость		= Ложь;
		Элементы.СписаниеВТМЦ.Видимость			= Ложь;
		Элементы.СписаниеВПродажу.Видимость		= Ложь;
		Элементы.СписаниеВЗаказНаряд.Видимость	= Ложь;
		Элементы.СписаниеНаСотрудника.Видимость = Истина;
		Элементы.СписаниеНаОтдел.Видимость		= Ложь;
		Элементы.Инициатор.Видимость 			= Ложь;
		
		НазначитьПустыеСсылки();
	КонецЕсли;
	///-ГомзМА 10.05.2023

КонецПроцедуры


&НаСервере
Процедура НазначитьПустыеСсылки()

	///+ГомзМА 10.05.2023
	Если Объект.ВидСписания = Перечисления.ВидыСписания.ВЗаказНаряд Тогда
		Объект.СписаниеВРасход 		= Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.СписаниеВТМЦ 		= Справочники.СкладСнабжение.ПустаяСсылка();
		Объект.СписаниеВПродажу 	= Документы.ПродажаЗапчастей.ПустаяСсылка();
		Объект.СписаниеНаСотрудника = Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.СписаниеНаОтдел 		= Справочники.МестаХраненияТМЦ.ПустаяСсылка();
	ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.ВОтдел Тогда
		Объект.СписаниеВРасход 		= Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.СписаниеВТМЦ 		= Справочники.СкладСнабжение.ПустаяСсылка();
		Объект.СписаниеВПродажу 	= Документы.ПродажаЗапчастей.ПустаяСсылка();
		Объект.СписаниеВЗаказНаряд 	= Документы.ЗаказНаряд.ПустаяСсылка();
		Объект.СписаниеНаСотрудника = Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.Инициатор 			= Справочники.Пользователи.ПустаяСсылка();
	ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.ВПродажу Тогда
		Объект.СписаниеВРасход 		= Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.СписаниеВТМЦ 		= Справочники.СкладСнабжение.ПустаяСсылка();
		Объект.СписаниеВЗаказНаряд 	= Документы.ЗаказНаряд.ПустаяСсылка();
		Объект.СписаниеНаСотрудника = Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.СписаниеНаОтдел 		= Справочники.МестаХраненияТМЦ.ПустаяСсылка();
	ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.КомплектацияТМЦ Тогда
		Объект.СписаниеВРасход 		= Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.СписаниеВПродажу 	= Документы.ПродажаЗапчастей.ПустаяСсылка();
		Объект.СписаниеВЗаказНаряд 	= Документы.ЗаказНаряд.ПустаяСсылка();
		Объект.СписаниеНаСотрудника = Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.СписаниеНаОтдел 		= Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.Инициатор 			= Справочники.Пользователи.ПустаяСсылка();
	ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.МусорВУтиль Тогда
		Объект.СписаниеВТМЦ 		= Справочники.СкладСнабжение.ПустаяСсылка();
		Объект.СписаниеВПродажу 	= Документы.ПродажаЗапчастей.ПустаяСсылка();
		Объект.СписаниеВЗаказНаряд 	= Документы.ЗаказНаряд.ПустаяСсылка();
		Объект.СписаниеНаСотрудника = Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.СписаниеНаОтдел 		= Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.Инициатор 			= Справочники.Пользователи.ПустаяСсылка();
	ИначеЕсли Объект.ВидСписания = Перечисления.ВидыСписания.Сотруднику Тогда
		Объект.СписаниеВРасход 		= Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.СписаниеВТМЦ 		= Справочники.СкладСнабжение.ПустаяСсылка();
		Объект.СписаниеВПродажу 	= Документы.ПродажаЗапчастей.ПустаяСсылка();
		Объект.СписаниеВЗаказНаряд 	= Документы.ЗаказНаряд.ПустаяСсылка();
		Объект.СписаниеНаОтдел 		= Справочники.МестаХраненияТМЦ.ПустаяСсылка();
		Объект.Инициатор 			= Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	///-ГомзМА 10.05.2023

КонецПроцедуры


&НаСервере
Функция ПечатьАктСписанияНаСервере()
	
	///+ГомзМА 14.04.2023 
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.СписаниеТМЦВорктрак.ПолучитьМакет("АктСписания");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписаниеТМЦВорктракСписокТМЦ.НомерСтроки КАК НомерСтроки,
	|	СписаниеТМЦВорктракСписокТМЦ.ТМЦ КАК ТМЦ,
	|	СписаниеТМЦВорктракСписокТМЦ.Количество КАК Количество,
	|	СписаниеТМЦВорктракСписокТМЦ.Цена КАК Цена,
	|	СписаниеТМЦВорктракСписокТМЦ.Сумма КАК Сумма,
	|	СписаниеТМЦВорктракСписокТМЦ.Склад КАК Склад,
	|	СписаниеТМЦВорктракСписокТМЦ.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	СписаниеТМЦВорктракСписокТМЦ.СерийныйНомер КАК СерийныйНомер,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Ссылка КАК Ссылка,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Ответственный КАК Ответственный,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Номер КАК Номер,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Дата КАК Дата,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Комментарий КАК Комментарий,
	|	СписаниеТМЦВорктракСписокТМЦ.СкладСписания КАК СкладСписания
	|ИЗ
	|	Документ.СписаниеТМЦВорктрак.СписокТМЦ КАК СписаниеТМЦВорктракСписокТМЦ
	|ГДЕ
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ВыборкаЗапрос = Запрос.Выполнить().Выбрать();
		
	ОбластьШапка = Макет.ПолучитьОбласть("ОбластьШапка");
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
	///-ГомзМА 14.04.2023
	
КонецФункции

&НаСервере
Функция ПечатьАктСписанияРасходниковНаСервере()
	
	///+ГомзМА 14.04.2023 
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.СписаниеТМЦВорктрак.ПолучитьМакет("АктСписанияРасходников");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписаниеТМЦВорктракСписокТМЦ.НомерСтроки КАК НомерСтроки,
	|	СписаниеТМЦВорктракСписокТМЦ.ТМЦ КАК ТМЦ,
	|	СписаниеТМЦВорктракСписокТМЦ.Количество КАК Количество,
	|	СписаниеТМЦВорктракСписокТМЦ.Цена КАК Цена,
	|	СписаниеТМЦВорктракСписокТМЦ.Сумма КАК Сумма,
	|	СписаниеТМЦВорктракСписокТМЦ.Склад КАК Склад,
	|	СписаниеТМЦВорктракСписокТМЦ.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	СписаниеТМЦВорктракСписокТМЦ.СерийныйНомер КАК СерийныйНомер,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Ссылка КАК Ссылка,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Ответственный КАК Ответственный,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Номер КАК Номер,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Дата КАК Дата,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Комментарий КАК Комментарий,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.СписаниеВРасход КАК СписаниеВРасход,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.СписаниеВТМЦ КАК СписаниеВТМЦ,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.СписаниеВПродажу КАК СписаниеВПродажу,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.СписаниеВЗаказНаряд КАК СписаниеВЗаказНаряд,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.СписаниеНаСотрудника КАК СписаниеНаСотрудника,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.СписаниеНаОтдел КАК СписаниеНаОтдел,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Инициатор КАК Инициатор,
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.ВидСписания КАК ВидСписания,
	|	СписаниеТМЦВорктракСписокТМЦ.СкладСписания КАК СкладСписания
	|ИЗ
	|	Документ.СписаниеТМЦВорктрак.СписокТМЦ КАК СписаниеТМЦВорктракСписокТМЦ
	|ГДЕ
	|	СписаниеТМЦВорктракСписокТМЦ.Ссылка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ВыборкаЗапрос = Запрос.Выполнить().Выбрать();
		
	ОбластьШапка = Макет.ПолучитьОбласть("ОбластьШапка");
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
	///-ГомзМА 14.04.2023
	
КонецФункции


#КонецОбласти


&НаКлиенте
Процедура СписокТМЦИнвентарныйНомерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	///+ГомзМА 19.05.2023
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элементы.СписокТМЦ.ТекущиеДанные;
	
	ОткрытьФорму("Справочник.ИнвентарныеНомера.ФормаВыбора",, ЭтаФорма,ЭтаФорма.УникальныйИдентификатор);
	///-ГомзМА 19.05.2023
	
КонецПроцедуры


&НаСервере
Процедура ПриЗакрытииФормыВыбора(Значение, ДопПараметры) Экспорт
	
	ДобавлениеИнвентарногоНомера(Значение, ДопПараметры);
	
КонецПроцедуры


&НаСервере
Процедура ДобавлениеИнвентарногоНомера(ДанныеЗаполнения, ИнвентарныйНомер)
	
	ИнвентарныйНомер = ДанныеЗаполнения.Ссылка;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Перем Команда;
	
	ТекСтрока = Элементы.СписокТМЦ.ТекущиеДанные;
	ВыбранноеЗначение.Свойство("Команда", Команда);
	Если Команда = "ПравильныйПоиск" Тогда
		ТекСтрока.ИнвентарныйНомер = ВыбранноеЗначение.Ссылка;
	КонецЕсли;
	
	
	ТекСтрока = Элементы.СписокТМЦ.ТекущиеДанные;
	
	РаботаСДокументамиТМЦКлиент.УстановитьДанныеПоИнвентарномуНомеру(ТекСтрока);
	
	ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
	
КонецПроцедуры



