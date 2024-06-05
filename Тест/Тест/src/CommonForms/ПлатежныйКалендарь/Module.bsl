Перем НачалоНедили;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НачалоНедили = НачалоНедели(ТекущаяДата()); 
	ОбновлениеСписков(НачалоНедили); 
	Период = ТекущаяДата(); 
	
	Элементы.ПонедельникВторник.Доступность = Ложь; 
	Элементы.СредаЧетверг.Доступность = Истина; 
	Элементы.Пятница.Доступность = Истина; 
	Элементы.ПервояСтрока.Видимость = Истина; 
	Элементы.ВтораяСтрока.Видимость = Ложь; 
	Элементы.ТретьяСтрока.Видимость = ложь; 
	
КонецПроцедуры

&НаСервере 
Процедура ОбновлениеСписков(НачалоНедили)	
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000001"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000002"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000004"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000005"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000006"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000009"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000010"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000014"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000017"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000021"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000022"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000024"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000025"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000026"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000027"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000029"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000030"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000031"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000032"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000037"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000038"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000039"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000040"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000041"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000042"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000043"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000045"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000046"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000047"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000048"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000049"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000052"));
	МассивСчетов.Добавить(Справочники.Счета.НайтиПоКоду("000000054"));
		
	СписокСчета.Параметры.УстановитьЗначениеПараметра	("МассивСчетов",МассивСчетов);
	СписокСчета.Параметры.УстановитьЗначениеПараметра	("Период",НачалоНедили);
	ДатаКалендаря = НачалоНедили; 
	СписокСчета1.Параметры.УстановитьЗначениеПараметра	("МассивСчетов",МассивСчетов);
	СписокСчета1.Параметры.УстановитьЗначениеПараметра	("Период",НачалоНедили + 86401 );
	ДатаКалендаря1 = НачалоНедили + 86401; 
	СписокСчета2.Параметры.УстановитьЗначениеПараметра	("МассивСчетов",МассивСчетов);
	СписокСчета2.Параметры.УстановитьЗначениеПараметра	("Период",НачалоНедили + 86401*2);
	ДатаКалендаря2 = НачалоНедили + 86401*2; 
	СписокСчета3.Параметры.УстановитьЗначениеПараметра	("МассивСчетов",МассивСчетов);
	СписокСчета3.Параметры.УстановитьЗначениеПараметра	("Период",НачалоНедили + 86401*3);
	ДатаКалендаря3 = НачалоНедили + 86401*3; 
	СписокСчета4.Параметры.УстановитьЗначениеПараметра	("МассивСчетов",МассивСчетов);
	СписокСчета4.Параметры.УстановитьЗначениеПараметра	("Период",НачалоНедили + 86401*4);
	ДатаКалендаря4 = НачалоНедили + 86401*4; 
		
конецПроцедуры

&НаКлиенте
Процедура ПонедельникВторник(Команда)
	Элементы.ПонедельникВторник.Доступность = Ложь; 
	Элементы.СредаЧетверг.Доступность = Истина; 
	Элементы.Пятница.Доступность = Истина; 
	Элементы.ПервояСтрока.Видимость = Истина; 
	Элементы.ВтораяСтрока.Видимость = Ложь; 
	Элементы.ТретьяСтрока.Видимость = ложь; 
КонецПроцедуры

&НаКлиенте
Процедура СредаЧетверк(Команда)
	Элементы.ПонедельникВторник.Доступность = Истина; 
	Элементы.СредаЧетверг.Доступность = Ложь; 
	Элементы.Пятница.Доступность = Истина; 
	Элементы.ПервояСтрока.Видимость = Ложь; 
	Элементы.ВтораяСтрока.Видимость = Истина; 
	Элементы.ТретьяСтрока.Видимость = ложь; 
КонецПроцедуры

&НаКлиенте
Процедура Пятница(Команда)
	Элементы.ПонедельникВторник.Доступность = Истина; 
	Элементы.СредаЧетверг.Доступность = Истина; 
	Элементы.Пятница.Доступность = ложь; 
	Элементы.ПервояСтрока.Видимость = Ложь; 
	Элементы.ВтораяСтрока.Видимость = Ложь; 
	Элементы.ТретьяСтрока.Видимость = Истина; 
КонецПроцедуры



&НаКлиенте
Процедура РасчедДнейНедели()  
	НачалоНедили = НачалоНедели(Период); 
	ОбновлениеСписков(НачалоНедили);
КонецПроцедуры 
&НаКлиенте
Процедура Обновить(Команда)
	РасчедДнейНедели();  	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	РасчедДнейНедели();  		
КонецПроцедуры
