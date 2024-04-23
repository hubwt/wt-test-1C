&НаКлиенте
Процедура ВыручкаПриИзменении(Элемент)
	ВыручкаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыручкаПриИзмененииНаСервере()
	Константы.ВыручкаПредприятия.Установить(Выручка);
КонецПроцедуры

&НаКлиенте
Процедура Суммировать(Команда)
	ПересчётИтогиДокументов();
КонецПроцедуры

Процедура ПересчётИтогиДокументов()
	//Запрос = новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	КадровыйПриказ.Сотрудник КАК Сотрудник,
	//               |	МАКСИМУМ(КадровыйПриказ.Дата) КАК ДатаДоговора
	//               |ПОМЕСТИТЬ ВТ_ДолжностиПериод
	//               |ИЗ
	//               |	Документ.КадровыйПриказ КАК КадровыйПриказ
	//               |ГДЕ
	//               |	(КадровыйПриказ.Отдел.Код = ""000000105""
	//               |			ИЛИ КадровыйПриказ.Отдел.Родитель.Код = ""000000105""
	//               |			ИЛИ КадровыйПриказ.Отдел.Родитель.Родитель.Код = ""000000105""
	//               |			ИЛИ КадровыйПриказ.Отдел.Родитель.Родитель.Родитель.Код = ""000000105"")
	//               |
	//               |СГРУППИРОВАТЬ ПО
	//               |	КадровыйПриказ.Сотрудник
	//               |;
	//               |
	//               |////////////////////////////////////////////////////////////////////////////////
	//               |ВЫБРАТЬ
	//               |	КадровыйПриказ.Отдел КАК Отдел,
	//               |	СУММА(КадровыйПриказ.Оклад) КАК Оклад,
	//               |	КОЛИЧЕСТВО(КадровыйПриказ.Сотрудник) КАК Сотрудник
	//               |ПОМЕСТИТЬ ВТ_Оклады
	//               |ИЗ
	//               |	Документ.КадровыйПриказ КАК КадровыйПриказ
	//               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ДолжностиПериод КАК ВТ_ДолжностиПериод
	//               |		ПО КадровыйПриказ.Сотрудник = ВТ_ДолжностиПериод.Сотрудник
	//               |			И (ВТ_ДолжностиПериод.ДатаДоговора = КадровыйПриказ.Дата)
	//               |
	//               |СГРУППИРОВАТЬ ПО
	//               |	КадровыйПриказ.Отдел
	//               |;
	//               |
	//               |////////////////////////////////////////////////////////////////////////////////
	//               |ВЫБРАТЬ
	//               |	Подразделения.Ссылка КАК Ссылка,
	//               |	Подразделения.Код КАК Код,
	//               |	Подразделения.Наименование КАК Наименование,
	//               |	Подразделения.ПроценОтВыручки КАК ПроценОтВыручки,
	//               |	ВТ_Оклады.Оклад КАК Оклад,
	//               |	ВТ_Оклады.Сотрудник КАК Сотрудник,
	//               |	ВыручкаПредприятия.Значение * (Подразделения.ПроценОтВыручки / 100) КАК ПремияНаОтдел,
	//               |	ВТ_Оклады.Оклад + ВыручкаПредприятия.Значение * (Подразделения.ПроценОтВыручки / 100) КАК ДоходОтдела
	//               |ИЗ
	//               |	Справочник.Подразделения КАК Подразделения
	//               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Оклады КАК ВТ_Оклады
	//               |		ПО (ВТ_Оклады.Отдел = Подразделения.Ссылка),
	//               |	Константа.ВыручкаПредприятия КАК ВыручкаПредприятия
	//               |ГДЕ
	//               |	(Подразделения.Код = ""000000105""
	//               |			ИЛИ Подразделения.Родитель.Код = ""000000105""
	//               |			ИЛИ Подразделения.Родитель.Родитель.Код = ""000000105""
	//               |			ИЛИ Подразделения.Родитель.Родитель.Родитель.Код = ""000000105"")";  
	//Выборка = Запрос.Выполнить().Выбрать();
	//
	//Пока Выборка.Следующий() Цикл
	//	ОбъектОтдела = Выборка.Ссылка.ПолучитьОбъект();
	//	ОбъектОтдела.доход = Выборка.ДоходОтдела; 
	//	ОбъектОтдела.Оклад =  Выборка.Оклад;
	//	ОбъектОтдела.Премия = Выборка.ПремияНаОтдел;
	//	ОбъектОтдела.КоличествоСотрудников = Выборка.Сотрудник; 
	//	ОбъектОтдела.Записать();
	//КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Подразделения.Премия КАК Премия,
	               |	Подразделения.Оклад КАК Оклад,
	               |	Подразделения.КоличествоСотрудников КАК КоличествоСотрудников,
	               |	Подразделения.Доход КАК Доход,
	               |	Подразделения.ПроценОтВыручки КАК ПроценОтВыручки,
	               |	Подразделения.Ссылка КАК Ссылка,
	               |	Подразделения.НеПерезаписывать КАК НеПерезаписывать
	               |ИЗ
	               |	Справочник.Подразделения КАК Подразделения
	               |ГДЕ
	               |	(Подразделения.Код = ""000000105""
	               |			ИЛИ Подразделения.Родитель.Код = ""000000105""
	               |			ИЛИ Подразделения.Родитель.Родитель.Код = ""000000105""
	               |			ИЛИ Подразделения.Родитель.Родитель.Родитель.Код = ""000000105"")
	               |ИТОГИ ПО
	               |	Ссылка ТОЛЬКО ИЕРАРХИЯ" ;

	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Доход = 0;
	Оклады =  0;
	Премия = 0;
	КоличествоСотрудников = 0;
	Процент = 0;
	Для Каждого СтрПервогоУровня Из Дерево.Строки Цикл
		
		Доход2 = 0;
		Оклады2 =  0;
		Премия2 = 0;
		КоличествоСотрудников2 = 0;
		Процент2 = 0;
		Для Каждого стрВторогоУровня Из СтрПервогоУровня.Строки Цикл
			
			Доход3 = 0;
			Оклады3 =  0;
			Премия3 = 0;
			КоличествоСотрудников3 = 0;
			Процент3 = 0;
			Для Каждого стрТретьегоУровня Из СтрВторогоУровня.Строки Цикл
				Доход4 = 0;
				Оклады4 =  0;
				Премия4 = 0;
				КоличествоСотрудников4 = 0;
				Процент4 = 0;
				Для Каждого стрЧетвёртогоУровня Из стрТретьегоУровня.Строки Цикл
					Если стрЧетвёртогоУровня.Ссылка <> стрТретьегоУровня.Ссылка тогда
						Доход4 = Доход4 + стрЧетвёртогоУровня.Доход;
						Оклады4 =  Оклады4 + стрЧетвёртогоУровня.Оклад;
						Премия4 = Премия4 + стрЧетвёртогоУровня.Премия;
						КоличествоСотрудников4 = КоличествоСотрудников4 + стрЧетвёртогоУровня.КоличествоСотрудников;
						Процент4 = Процент4 + стрЧетвёртогоУровня.ПроценОтВыручки;
					КонецЕсли;
					
				КонецЦикла;
				
				Если Не стрТретьегоУровня.НеПерезаписывать И Доход4 > 0 Тогда
					ОбъектОтдела = стрТретьегоУровня.Ссылка.ПолучитьОбъект();
					ОбъектОтдела.доход = Доход4;
					ОбъектОтдела.Оклад =  Оклады4;
					ОбъектОтдела.Премия = Премия4;
					ОбъектОтдела.КоличествоСотрудников = КоличествоСотрудников4;
					ОбъектОтдела.ПроценОтВыручки = Процент4;
					ОбъектОтдела.Записать();
				КонецЕсли;
				Если стрТретьегоУровня.Ссылка <> стрВторогоУровня.Ссылка тогда
					Доход3 = Доход3 + стрТретьегоУровня.Доход;
					Оклады3 =  Оклады3 + стрТретьегоУровня.Оклад;
					Премия3 = Премия3 + стрТретьегоУровня.Премия;
					КоличествоСотрудников3 = КоличествоСотрудников3 + стрТретьегоУровня.КоличествоСотрудников;
					Процент3 = Процент3 + стрТретьегоУровня.ПроценОтВыручки;
				КонецЕсли;
			КонецЦикла;
			
			Если Не стрВторогоУровня.НеПерезаписывать И Доход3 > 0 Тогда
				ОбъектОтдела = стрВторогоУровня.Ссылка.ПолучитьОбъект();
				ОбъектОтдела.доход = Доход3;
				ОбъектОтдела.Оклад =  Оклады3;
				ОбъектОтдела.Премия = Премия3;
				ОбъектОтдела.КоличествоСотрудников = КоличествоСотрудников3;
				ОбъектОтдела.ПроценОтВыручки = Процент3;
				ОбъектОтдела.Записать();
			КонецЕсли;
			Если стрВторогоУровня.Ссылка <> СтрПервогоУровня.Ссылка тогда
				Доход2 = Доход2 + стрВторогоУровня.Доход;
				Оклады2 =  Оклады2 + стрВторогоУровня.Оклад;
				Премия2 = Премия2 + стрВторогоУровня.Премия;
				КоличествоСотрудников2 = КоличествоСотрудников2 + стрВторогоУровня.КоличествоСотрудников;
				Процент2 = Процент2 + стрВторогоУровня.ПроценОтВыручки;
			КонецЕсли;
		КонецЦикла;
		
		Если Не СтрПервогоУровня.НеПерезаписывать И Доход2 > 0 Тогда
			ОбъектОтдела = СтрПервогоУровня.Ссылка.ПолучитьОбъект();
			ОбъектОтдела.доход = Доход2;
			ОбъектОтдела.Оклад =  Оклады2;
			ОбъектОтдела.Премия = Премия2;
			ОбъектОтдела.КоличествоСотрудников = КоличествоСотрудников2;
			ОбъектОтдела.ПроценОтВыручки = Процент2;
			ОбъектОтдела.Записать();
		КонецЕсли;
	КонецЦикла;
	
				
	
	
	//Пока Выборка.Следующий() Цикл
	//	//Попытка
	//	ОбъектОтдела = Выборка.РодительСсылка.ПолучитьОбъект();
	//	ОбъектОтдела.доход = Выборка.Доход; 
	//	ОбъектОтдела.Оклад =  Выборка.Оклад;
	//	ОбъектОтдела.Премия = Выборка.Премия;
	//	ОбъектОтдела.КоличествоСотрудников = Выборка.КоличествоСотрудников; 
	//	ОбъектОтдела.Записать();
	////Исключение
	//	//КонецПопытки;
	//КонецЦикла;

	//Запрос = новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	СУММА(Подразделения.Премия) КАК Премия,
	//               |	СУММА(Подразделения.Оклад) КАК Оклад,
	//               |	СУММА(Подразделения.КоличествоСотрудников) КАК КоличествоСотрудников,
	//               |	СУММА(Подразделения.Доход) КАК Доход,
	//               |	СРЕДНЕЕ(Подразделения.ПроценОтВыручки) КАК ПроценОтВыручки,
	//               |	Подразделения.Родитель.Родитель КАК РодительСсылка
	//               |ИЗ
	//               |	Справочник.Подразделения КАК Подразделения
	//               |ГДЕ
	//               |	(Подразделения.Код = ""000000105""
	//               |			ИЛИ Подразделения.Родитель.Код = ""000000105""
	//               |			ИЛИ Подразделения.Родитель.Родитель.Код = ""000000105""
	//               |			ИЛИ Подразделения.Родитель.Родитель.Родитель.Код = ""000000105"")
	//               |	И Подразделения.Родитель.Родитель.Ссылка <> ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	//               |
	//               |СГРУППИРОВАТЬ ПО
	//               |	Подразделения.Родитель.Родитель";  
	//Выборка = Запрос.Выполнить().Выбрать();

	//
	//Пока Выборка.Следующий() Цикл
	//	//Попытка
	//	ОбъектОтдела = Выборка.РодительСсылка.ПолучитьОбъект();
	//	ОбъектОтдела.доход = Выборка.Доход; 
	//	ОбъектОтдела.Оклад =  Выборка.Оклад;
	//	ОбъектОтдела.Премия = Выборка.Премия;
	//	ОбъектОтдела.КоличествоСотрудников = Выборка.КоличествоСотрудников; 
	//	ОбъектОтдела.Записать();
	////Исключение
	//	//КонецПопытки;
	//КонецЦикла;

	

	//Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
    //Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
    //КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
    //МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
    //ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
    //ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
    //ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
    //Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	//Доход =   Формат(Результат.Итог("Доход"),"ЧДЦ=0; ЧН=-");
	//Премия =  Формат(Результат.Итог("Премия"),"ЧДЦ=0; ЧН=-");
	//Оклады =  Формат(Результат.Итог("Оклад"),"ЧДЦ=0; ЧН=-");

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Выручка = Константы.ВыручкаПредприятия.Получить();
КонецПроцедуры