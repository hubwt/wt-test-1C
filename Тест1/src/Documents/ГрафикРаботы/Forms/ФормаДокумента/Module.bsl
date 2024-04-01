
&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ПодразделениеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииНаСервере()
	Если ЗначениеЗаполнено(Объект.Период) и значениеЗаполнено(Объект.Подразделение) Тогда
		объект.График.Очистить();
		Запрос = новый Запрос;
		Запрос.Текст =  "ВЫБРАТЬ
		                |	ДолжностиСотрудниковСрезПоследних.Подразделение КАК Подразделение,
		                |	ДолжностиСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
		                |	ДолжностиСотрудниковСрезПоследних.Должность КАК Должность
		                |ИЗ
		                |	РегистрСведений.ДолжностиСотрудников.СрезПоследних КАК ДолжностиСотрудниковСрезПоследних
		                |ГДЕ
		                |	ДолжностиСотрудниковСрезПоследних.Подразделение = &Подразделение
		                |	И ДолжностиСотрудниковСрезПоследних.ТипДоговора <> &ТипДоговора";
		Запрос.УстановитьПараметр("Подразделение",Объект.Подразделение);
		Запрос.УстановитьПараметр("ТипДоговора",Справочники.ТипыКадровыхДоговоров.НайтиПоКоду("000000004"));

		СотрудникиПодразделения = Запрос.Выполнить().Выбрать();
		
		Запрос = новый Запрос;
		Запрос.Текст =  "ВЫБРАТЬ
		|	ДанныеПроизводственногоКалендаря.Дата КАК Дата,
		|	ДанныеПроизводственногоКалендаря.ВидДня КАК ВидДня
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ
		|	ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &ДатаНач И &ДатаКон";
		Запрос.УстановитьПараметр("ДатаНач",НачалоМесяца(Объект.Период));
		Запрос.УстановитьПараметр("ДатаКон",КонецМесяца(Объект.Период));
		
		
		
		Пока СотрудникиПодразделения.Следующий() Цикл
			//@skip-check query-in-loop
			ДатыКалендаря = Запрос.Выполнить().Выбрать();
			Пока ДатыКалендаря.Следующий() Цикл
				НоваяСтрока 		  = объект.График.Добавить();
				НоваяСтрока.Сотрудник = СотрудникиПодразделения.Сотрудник;
				Новаястрока.Дата      = ДатыКалендаря.дата;
				Если ДатыКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий тогда
					Новаястрока.ТипДня    = перечисления.ТипыДнейТабеля.РабочийДень;
				ИначеЕсли ДатыКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота или ДатыКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье или ДатыКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник или ДатыКалендаря.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Нерабочий тогда
					Новаястрока.ТипДня    = перечисления.ТипыДнейТабеля.Выходной;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("Значение", Объект.Период);
	ПараметрыОткрытия.Вставить("РежимВыбораПериода", "Месяц");
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПериодНачалоВыбораНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериода", , ЭтаФорма, ЭтаФорма.УникальныйИдентификатор,,,ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбораНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение =  РезультатЗакрытия;
	Если Объект.Период <> ВыбранноеЗначение Тогда
		Объект.Период = ВыбранноеЗначение;
	КонецЕсли;
	ПодразделениеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Запрос = Новый Запрос;
	//Запрос.Текст =  "ВЫБРАТЬ
	//                |	ГрафикРаботыГрафик.Сотрудник КАК Сотрудник,
	//                |	ГрафикРаботыГрафик.Дата КАК Дата,
	//                |	ГрафикРаботыГрафик.ТипДня КАК ТипДня
	//                |ИЗ
	//                |	Документ.ГрафикРаботы.График КАК ГрафикРаботыГрафик
	//                |ГДЕ
	//                |	ГрафикРаботыГрафик.Ссылка = &Ссылка
	//                |
	//                |СГРУППИРОВАТЬ ПО
	//                |	ГрафикРаботыГрафик.Сотрудник,
	//                |	ГрафикРаботыГрафик.Дата,
	//                |	ГрафикРаботыГрафик.ТипДня
	//                |
	//                |УПОРЯДОЧИТЬ ПО
	//                |	Сотрудник,
	//                |	Дата
	//                |ИТОГИ
	//                |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Дата),
	//                |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТипДня)
	//                |ПО
	//                |	Сотрудник";
	//Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	//Табло = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	//Объект.График.Загрузить(Табло);
КонецПроцедуры




