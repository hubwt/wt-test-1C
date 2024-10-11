
&НаКлиенте
Процедура ФотоДетали(Команда)
	
ОбщДействия.ОткрытьДетальНаСайтеWT10(Элементы.АналитикаЦен.ТекущиеДанные.ИндНомер);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьПодвал();
	ПоказатьКоличесвтоЗаписей();
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьКоличесвтоЗаписей()

	Схема = Элементы.АналитикаЦен.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
    Настройки = Элементы.АналитикаЦен.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
    МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
    ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
    Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	ВсегоЗаписей = Результат.Количество(); 
	
	ВПродаже = 0;
	ВНаличии = 0;
	
	Для каждого Строка из Результат Цикл
		Если Строка.Статус = "Продан" Тогда
			ВПродаже = ВПродаже + 1;
		ИначеЕсли Строка.Статус = "В наличии" Тогда
			ВНаличии = ВНаличии + 1;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоВсего = ВсегоЗаписей;
	КоличествоПродано = ВПродаже;
	КоличествоВНаличии = ВНаличии;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодвал()
	
	Схема = Элементы.АналитикаЦен.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.АналитикаЦен.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.АналитикаЦенНачисления.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.АналитикаЦенСуммаПродажи.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.АналитикаЦенЦена.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	
	ЭтотОбъект.ЭтаФорма.Элементы.АналитикаЦенНачисления.ТекстПодвала =  Формат(Результат.Итог("Начисления"),"ЧДЦ=2; ЧН=-;");
	ЭтотОбъект.ЭтаФорма.Элементы.АналитикаЦенСуммаПродажи.ТекстПодвала =  Формат(Результат.Итог("СуммаПродажи"),"ЧДЦ=2; ЧН=-;");
	ЭтотОбъект.ЭтаФорма.Элементы.АналитикаЦенЦена.ТекстПодвала =  Формат(Результат.Итог("Цена"),"ЧДЦ=2; ЧН=-;");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПодвал(Команда)
	
	ЗаполнитьПодвал();
	
КонецПроцедуры

