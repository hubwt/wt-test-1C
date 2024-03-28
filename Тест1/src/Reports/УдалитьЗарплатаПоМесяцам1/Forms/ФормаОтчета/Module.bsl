
&НаКлиенте
Процедура ПриОткрытии(Отказ)
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    СписокПродаж.Параметры.УстановитьЗначениеПараметра("КтоПродал",Справочники.Пользователи.НайтиПоНаименованию("Алексей"));
	Пользователь = Справочники.Пользователи.НайтиПоНаименованию("Алексей");
	Пользователь2 = Справочники.Пользователи.НайтиПоНаименованию("Рожков Александр");
	Год = Год(ТекущаяДата()); 
	Месяц = Месяц(ТекущаяДата()); 
	Год2 = Год(ТекущаяДата()); 
	Месяц2 = Месяц(ТекущаяДата()); 
	Показывать1 = ИСТИНА;
	ОбновитьСуммы();
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ОбновитьСуммы();
КонецПроцедуры

&НаКлиенте
Процедура Месяц1ПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ОбновитьСуммы();
КонецПроцедуры

&НаКлиенте
Процедура Год1ПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ОбновитьСуммы();
КонецПроцедуры


&НаСервере
Процедура ОбновитьСуммы()
	 податам = ложь;
	 Если Показывать1 = Истина Тогда
	 	Текст2 = "ВЫБРАТЬ
	          |	ПродажаЗапчастей.Ссылка,
	          |	ПродажаЗапчастей.ИтогоРекв,
	          |	ПродажаЗапчастей.Оплачено,
			  |	ПродажаЗапчастей.Комментарий,
	          |	ПродажаЗапчастей.ИтогоРекв * 0.05 КАК Заработано
	          |ИЗ
	          |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	          |ГДЕ
	          |	ПродажаЗапчастей.Оплачено = ИСТИНА
	          |	И ПродажаЗапчастей.КтоПродал = &КтоПродал";
	Иначе
		Текст2 = "ВЫБРАТЬ
	          |	ПродажаЗапчастей.Ссылка,
	          |	ПродажаЗапчастей.ИтогоРекв,
	          |	ПродажаЗапчастей.Оплачено,
			  |	ПродажаЗапчастей.Комментарий,
	          |	ПродажаЗапчастей.ИтогоРекв * 0.05 КАК Заработано
	          |ИЗ
	          |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	          |ГДЕ
	          |	ПродажаЗапчастей.Оплачено = ИСТИНА";
	КонецЕсли;
			  
	 Если Год >= 2011 ИЛИ  Месяц > 0 Тогда
		 податам = истина;
		 Если Месяц  > 0 И Год < 2011 Тогда
			 Год = Год(ТекущаяДата());
		 КонецЕсли;
	 КонецЕсли;
	 Запрос = Новый Запрос;
	 Текст = "ВЫБРАТЬ
	         |	ПродажаЗапчастей.ИтогоРекв * 0.05 КАК Поле1
	         |ИЗ
	         |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	         |ГДЕ
	         |	ПродажаЗапчастей.КтоПродал = &КтоПродал
	         |	И ПродажаЗапчастей.Оплачено = ИСТИНА";

	Если податам Тогда				
		Если Месяц > 0 Тогда
			Дат1 = Дата(Год,Месяц,1);
			Дат2 = КонецМесяца(Дат1);
		Иначе
		   Дат1 = Дата(Год,1,1);
		   Дат2 = КонецГода(Дат1);
	   КонецЕсли;
	   Текст = Текст + " И ПродажаЗапчастей.Дата >= &Дата1 И ПродажаЗапчастей.Дата < &Дата2";
	   Текст2 = Текст2 + " И ПродажаЗапчастей.Дата >= &Дата1 И ПродажаЗапчастей.Дата < &Дата2";
	   Запрос.Текст = Текст;

	   СписокПродаж.ТекстЗапроса = Текст2;
	   Если Показывать1 Тогда
		   СписокПродаж.Параметры.УстановитьЗначениеПараметра("Дата1",Дат1);
		   СписокПродаж.Параметры.УстановитьЗначениеПараметра("Дата2",Дат2);
	   КонецЕсли;
	   
	   Запрос.УстановитьПараметр("Дата1",Дат1);
	   Запрос.УстановитьПараметр("Дата2",Дат2);
   Иначе
	   Запрос.Текст = Текст;
	    СписокПродаж.ТекстЗапроса = Текст2;
	КонецЕсли; 
	Если Показывать1 Тогда
   		СписокПродаж.Параметры.УстановитьЗначениеПараметра("КтоПродал",Пользователь);
	КонецЕсли;
	
   Запрос.УстановитьПараметр("КтоПродал",Пользователь);

   Итого = Запрос.Выполнить().Выгрузить().Итог("Поле1");
   
	Текст = "ВЫБРАТЬ
	        |	Расходы.Сумма
	        |ИЗ
	        |	Документ.Расходы КАК Расходы
	        |ГДЕ
	        |	Расходы.Зарплата = ИСТИНА
	        |	И Расходы.Работник = &Пользователь";
	Запрос.Текст = Текст;
	Если податам Тогда
		Если Месяц > 0 Тогда		
	    	Текст = Текст + " И Расходы.Месяц = " + Месяц + " И Расходы.Год = &Год";
		Иначе
			Текст = Текст + " И Расходы.Год = &Год";
		КонецЕсли;
		Запрос.Текст = Текст;

		Запрос.УстановитьПараметр("Год",Год);


	КонецЕсли;
	
	Если податам И Месяц  > 0 Тогда 
		Фикс1 = Пользователь.ФиксированаяЧастьЗарплаты;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Пользователь",Пользователь);
	Выдано = Запрос.Выполнить().Выгрузить().Итог("Сумма");
	
	Текст = "ВЫБРАТЬ
	        |	Статистика.ИтогоСумма
	        |ИЗ
	        |	Документ.Статистика КАК Статистика
	        |ГДЕ
	        |	Статистика.Кому = &Пользователь
	        |	И Статистика.Зарплата = ИСТИНА";
			
	Запрос.Текст = Текст;
	Если податам Тогда
		Если Месяц > 0 Тогда		
	    	Текст = Текст + " И Статистика.Месяц = " + Месяц + " И Статистика.Год = &Год";
		Иначе
			Текст = Текст + " И Статистика.Год = &Год";
		КонецЕсли;
		Запрос.Текст = Текст;

		Запрос.УстановитьПараметр("Год",Год);


	КонецЕсли;
	
	Запрос.УстановитьПараметр("Пользователь",Пользователь);
	Выдано = Выдано + Запрос.Выполнить().Выгрузить().Итог("ИтогоСумма");
	
	Если Итого > 0 ИЛИ Фикс1 > 0 Тогда
		Осталось = Итого - Выдано + Фикс1;
	Иначе
		Осталось = 0;
	КонецЕсли;
	ОбновитьСуммы2();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСуммы2()
	 податам = ложь;
	 Текст2 = "ВЫБРАТЬ
			          |	ПродажаЗапчастей.Ссылка,
			          |	ПродажаЗапчастей.ИтогоРекв,
			          |	ПродажаЗапчастей.Оплачено,
					  |	ПродажаЗапчастей.Комментарий,
			          |	ПродажаЗапчастей.ИтогоРекв * 0.05 КАК Заработано
			          |ИЗ
			          |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
			          |ГДЕ
			          |	ПродажаЗапчастей.Оплачено = ИСТИНА";
	Если Год2 >= 2011 ИЛИ  Месяц2 > 0 Тогда
		 податам = истина;
		 Если Месяц2  > 0 И Год2 < 2011 Тогда
			 Год2 = Год(ТекущаяДата());
		 КонецЕсли;
		 Если Месяц2 > 0 Тогда
			Дат3 = Дата(Год2,Месяц2,1);
			Дат4 = КонецМесяца(Дат3);
		Иначе
		   Дат3 = Дата(Год2,1,1);
		   Дат4 = КонецГода(Дат3);
	   КонецЕсли;

	 КонецЕсли;
	 Если Показывать2 = ИСТИНА Тогда
		 податам1 = ложь;
		 Если Год >= 2011 ИЛИ  Месяц > 0 Тогда
			 податам1 = истина;
			 Если Месяц  > 0 И Год < 2011 Тогда
				 Год = Год(ТекущаяДата());
			 КонецЕсли;
			 Если Месяц > 0 Тогда
				Дат1 = Дата(Год,Месяц,1);
				Дат2 = КонецМесяца(Дат1);
			 Иначе
			   Дат1 = Дата(Год,1,1);
			   Дат2 = КонецГода(Дат1);
		     КонецЕсли;
	     КонецЕсли;
		 Если Показывать1 = Истина Тогда
			 Если податам1 Тогда
				 Текст2 = "ВЫБРАТЬ
			          |	ПродажаЗапчастей.Ссылка,
			          |	ПродажаЗапчастей.ИтогоРекв,
			          |	ПродажаЗапчастей.Оплачено,
					  |	ПродажаЗапчастей.Комментарий,
			          |	ПродажаЗапчастей.ИтогоРекв * 0.05 КАК Заработано
			          |ИЗ
			          |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
			          |ГДЕ
			          |	ПродажаЗапчастей.Оплачено = ИСТИНА
			          |	И ((ПродажаЗапчастей.КтоПродал = &КтоПродал  И ПродажаЗапчастей.Дата >= &Дата1 И ПродажаЗапчастей.Дата < &Дата2) ИЛИ (ПродажаЗапчастей.КтоПродал = &КтоПродал2";
			Иначе
				Текст2 = "ВЫБРАТЬ
			          |	ПродажаЗапчастей.Ссылка,
			          |	ПродажаЗапчастей.ИтогоРекв,
			          |	ПродажаЗапчастей.Оплачено,
					  |	ПродажаЗапчастей.Комментарий,
			          |	ПродажаЗапчастей.ИтогоРекв * 0.05 КАК Заработано
			          |ИЗ
			          |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
			          |ГДЕ
			          |	ПродажаЗапчастей.Оплачено = ИСТИНА
			          |	И ((ПродажаЗапчастей.КтоПродал = &КтоПродал) ИЛИ (ПродажаЗапчастей.КтоПродал = &КтоПродал2";
			КонецЕсли;
		Иначе
			Текст2 = "ВЫБРАТЬ
			          |	ПродажаЗапчастей.Ссылка,
			          |	ПродажаЗапчастей.ИтогоРекв,
			          |	ПродажаЗапчастей.Оплачено,
					  |	ПродажаЗапчастей.Комментарий,
			          |	ПродажаЗапчастей.ИтогоРекв * 0.05 КАК Заработано
			          |ИЗ
			          |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
			          |ГДЕ
			          |	ПродажаЗапчастей.Оплачено = ИСТИНА
			          |	И ((ПродажаЗапчастей.КтоПродал = &КтоПродал2 ";	
		КонецЕсли; 
		Если податам Тогда
			Текст2 = Текст2 + " И ПродажаЗапчастей.Дата >= &Дата3 И ПродажаЗапчастей.Дата < &Дата4";
		КонецЕсли;
		Текст2 = Текст2 + " ))";
		СписокПродаж.ТекстЗапроса = Текст2;

		 СписокПродаж.Параметры.УстановитьЗначениеПараметра("КтоПродал2",Пользователь2);

		   СписокПродаж.Параметры.УстановитьЗначениеПараметра("Дата3",Дат3);
		   СписокПродаж.Параметры.УстановитьЗначениеПараметра("Дата4",Дат4);


	КонецЕсли;
	
			
			  
				  
	 Если Год2 >= 2011 ИЛИ  Месяц2 > 0 Тогда
		 податам = истина;
		 Если Месяц2  > 0 И Год2 < 2011 Тогда
			 Год2 = Год(ТекущаяДата());
		 КонецЕсли;
	 КонецЕсли;
	 Запрос = Новый Запрос;
	 Текст = "ВЫБРАТЬ
	         |	ПродажаЗапчастей.ИтогоРекв * 0.05 КАК Поле1
	         |ИЗ
	         |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	         |ГДЕ
	         |	ПродажаЗапчастей.КтоПродал = &КтоПродал
	         |	И ПродажаЗапчастей.Оплачено = ИСТИНА";

	Если податам Тогда				
	   Текст = Текст + " И ПродажаЗапчастей.Дата >= &Дата1 И ПродажаЗапчастей.Дата < &Дата2";
	   Запрос.Текст = Текст;
	   Запрос.УстановитьПараметр("Дата1",Дат3);
	   Запрос.УстановитьПараметр("Дата2",Дат4);
   Иначе
	   Запрос.Текст = Текст;
	    СписокПродаж.ТекстЗапроса = Текст2;
   КонецЕсли; 
   Запрос.УстановитьПараметр("КтоПродал",Пользователь2);

   Итого2 = Запрос.Выполнить().Выгрузить().Итог("Поле1");
   
	Текст = "ВЫБРАТЬ
	        |	Расходы.Сумма
	        |ИЗ
	        |	Документ.Расходы КАК Расходы
	        |ГДЕ
	        |	Расходы.Зарплата = ИСТИНА
	        |	И Расходы.Работник = &Пользователь";
	Запрос.Текст = Текст;
	Если податам Тогда
		Если Месяц2 > 0 Тогда		
	    	Текст = Текст + " И Расходы.Месяц = " + Месяц2 + " И Расходы.Год = &Год";
		Иначе
			Текст = Текст + " И Расходы.Год = &Год";
		КонецЕсли;
		Запрос.Текст = Текст;

		Запрос.УстановитьПараметр("Год",Год2);


	КонецЕсли;
	
	Запрос.УстановитьПараметр("Пользователь",Пользователь2);
	Выдано2 = Запрос.Выполнить().Выгрузить().Итог("Сумма");
	
	
	Текст = "ВЫБРАТЬ
	        |	Статистика.ИтогоСумма
	        |ИЗ
	        |	Документ.Статистика КАК Статистика
	        |ГДЕ
	        |	Статистика.Кому = &Пользователь
	        |	И Статистика.Зарплата = ИСТИНА";
			
	Запрос.Текст = Текст;
	Если податам Тогда
		Если Месяц > 0 Тогда		
	    	Текст = Текст + " И Статистика.Месяц = " + Месяц + " И Статистика.Год = &Год";
		Иначе
			Текст = Текст + " И Статистика.Год = &Год";
		КонецЕсли;
		Запрос.Текст = Текст;

		Запрос.УстановитьПараметр("Год",Год);


	КонецЕсли;
	
	Запрос.УстановитьПараметр("Пользователь",Пользователь2);
	Выдано2 = Выдано2 + Запрос.Выполнить().Выгрузить().Итог("ИтогоСумма");
	
	
	Если податам И Месяц  > 0 Тогда 
		Фикс2 = Пользователь2.ФиксированаяЧастьЗарплаты;
	КонецЕсли;
	
	Если Итого2 > 0 ИЛИ Фикс2 > 0 Тогда
		Осталось2 = Итого2 - Выдано2 + Фикс2;
	Иначе
		Осталось2 = 0;
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура СписокПродажСсылкаНажатие(Элемент, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	КонецПроцедуры


&НаКлиенте
Процедура ОткрытьПродажу(Команда)
	// Вставить содержимое обработчика.
	стр = Элементы.СписокПродаж.ТекущиеДанные;
	стр.Ссылка.ПолучитьФорму().ОткрытьМодально();
КонецПроцедуры

&НаКлиенте
Процедура Показывать1ПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ОбновитьСуммы();

КонецПроцедуры

&НаКлиенте
Процедура Показывать2ПриИзменении(Элемент)
	ОбновитьСуммы();
КонецПроцедуры


