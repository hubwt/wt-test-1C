
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Вставить содержимое обработчика
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Событие = "Создал запись в чек листе: " + Запись.Описание;
	ЗаписьЛога(Событие);
КонецПроцедуры


Процедура ЗаписьЛога(Событие)
	
	ТекстЛога =  "----------------------------------------------------" + Символы.ПС + ТекущаяДата() + Символы.ПС  + "Пользователь " + Пользователи.ТекущийПользователь() + Символы.ПС +" "+ Событие + Символы.ПС ;
	
	ЗаписьВЛог = РегистрыСведений.ЛогЗадач.СоздатьМенеджерЗаписи();
	ЗаписьВЛог.Задача 		 = Запись.Задача;
	ЗаписьВЛог.Дата 		 = Запись.Дата;
	ЗаписьВЛог.Автор	     = Пользователи.ТекущийПользователь();
	ЗаписьВЛог.Текст         = ТекстЛога;
	ЗаписьВЛог.Записать();
	
КонецПроцедуры


&НаСервере
Процедура Проверказадачи()
	//Запрос = Новый запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	ЧекЛисты.Задача КАК Задача,
	//               |	ЧекЛисты.Ответственный КАК Ответственный,
	//               |	ЧекЛисты.Порядок КАК Порядок
	//               |ИЗ
	//               |	РегистрСведений.ЧекЛисты КАК ЧекЛисты
	//               |ГДЕ
	//               |	ЧекЛисты.Задача = &задача
	//               |	И ЧекЛисты.Ответственный = &Ответственный";
	//Запрос.УстановитьПараметр("Задача",Запись.Ссылка);
	//Запрос.УстановитьПараметр("Ответственный",Запись.Ответственный);

	//Таблица = Запрос.Выполнить().Выгрузить();
	Если Запись.Порядок = Неопределено Или Запись.Порядок = 0 тогда
		 Последниезадачи();
	КонецЕсли;
	
КонецПроцедуры


Процедура Последниезадачи()
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЧекЛисты.Задача КАК Задача,
	               |	ЧекЛисты.Ответственный КАК Ответственный,
				   |	ЧекЛисты.Дата КАК Дата,
	               |	ЧекЛисты.Порядок КАК Порядок
	               |ИЗ
	               |	РегистрСведений.ЧекЛисты КАК ЧекЛисты
	               |ГДЕ
	               |	ЧекЛисты.Ответственный = &Ответственный
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Порядок УБЫВ";
	Запрос.УстановитьПараметр("Ответственный",Запись.Ответственный);
	
	Выборка = Запрос.Выполнить().Выбрать(); 
	Выборка.Следующий();

	Если Выборка.Порядок = Неопределено Или Выборка.Порядок = 0 тогда
		Запись.Порядок     = 1;		
	Иначе
		Запись.Порядок     = Выборка.Порядок +1;
	КонецЕсли;
	
КонецПроцедуры		


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Проверказадачи();
КонецПроцедуры

