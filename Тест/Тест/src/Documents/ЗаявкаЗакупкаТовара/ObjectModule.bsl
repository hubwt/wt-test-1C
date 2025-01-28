Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
    	Возврат;
	КонецЕсли;
	// ++ Изменить ОБъект Заказнаряд. Пометить статусом "Заказано" товары
	
	ОбъектОснования = Основание.ПолучитьОбъект(); 
	
	Для каждого Строка ИЗ ЗакупленныйТовар Цикл 
		
		Для каждого СтрокаОснования ИЗ ОбъектОснования.Товары Цикл 
			
			Если Строка.Товар  = СтрокаОснования.Номенклатура 
				И (СтрокаОснования.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Планово
					ИЛИ  СтрокаОснования.Состояние  =Перечисления.СтатусыТовараВЗаказНаряде.Срочно
						ИЛИ СтрокаОснования.Состояние  =Перечисления.СтатусыТовараВЗаказНаряде.НетВНаличии)
					 		ТОгда 
								СтрокаОснования.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Заказано; 
								ОбъектОснования.Записать();
			КонецЕсли; 
			
		КонецЦикла;
		
	КонецЦикла;
	// -- Изменить ОБъект Заказнаряд. Пометить статусом "Заказано" товары
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТИПЗНЧ(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаряд")  Тогда
		СтатусЗаявки	= Перечисления.СтатусыЗаявкаЗакупкаТоваров.Ожидание; 
		Основание = ДанныеЗаполнения;  
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ЗаказНарядДефектовочныйЛист.Номенклатура КАК Товар,
			|	ЗаказНарядДефектовочныйЛист.Количество КАК Количество,
			|	ЗаказНарядДефектовочныйЛист.Цена КАК ЦенаВЗаказНаряде,
			|	ЗаказНарядДефектовочныйЛист.Комментарий КАК Комментарий,
			|	ЗаказНарядДефектовочныйЛист.Остаток КАК Остаток
			|ИЗ
			|	Документ.ЗаказНаряд.ДефектовочныйЛист КАК ЗаказНарядДефектовочныйЛист
			|ГДЕ
			|	ЗаказНарядДефектовочныйЛист.Ссылка = &СсылкаЗакНар
			|	И ЗаказНарядДефектовочныйЛист.Остаток = ""Нет на складе""";
		
		Запрос.УстановитьПараметр("СсылкаЗакНар",Основание);
		РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		ЗакупленныйТовар.Загрузить(РезультатЗапроса);
		
		Для каждого Строка ИЗ ЗакупленныйТовар Цикл 
			Строка.Сумма = Строка.ЦенаВЗаказНаряде * Строка.Количество; 
			СуммаДокумента = СуммаДокумента	+ (Строка.ЦенаВЗаказНаряде * Строка.Количество);
		КонецЦикла;
			
	КонецЕСли; 
	
	КонецПроцедуры
























