#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти



#Область СлужебныеПроцедурыИФункции

Процедура УстановитьУсловноеОформление()
	// Полписан
	ЭлементУО = Список.УсловноеОформление.Элементы.Добавить();
	
	
//	ГруппаИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ЭлементУО.Отбор.Элементы, "И", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
//	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаИ,
//		"ДатаОкончанияДействия", ВидСравненияКомпоновкиДанных.БольшеИлиРавно, НачалоДня(ТекущаяДата()));
//	Шрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Подписан", ВидСравненияКомпоновкиДанных.Равно, Ложь);
//	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Шрифт", Шрифт);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

	
	// Дата окончания
	ЭлементУО = Список.УсловноеОформление.Элементы.Добавить();
	ГруппаИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ЭлементУО.Отбор.Элементы, "И", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаИ,
		"ДатаОкончанияДействия", ВидСравненияКомпоновкиДанных.Меньше, НачалоДня(ТекущаяДата()));
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаИ,
		"ДатаОкончанияДействия", ВидСравненияКомпоновкиДанных.Заполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы




#КонецОбласти