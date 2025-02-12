
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Сотрудник  <> Справочники.Сотрудники.ПустаяСсылка() Тогда
		Объект.Сотрудник = Параметры.Сотрудник;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОдобреноРуководителемНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	//Элементы.ОдобреноРуководителем.Очистить();
	
	ДанныеВыбора = СформироватьРуководителей();    
	
КонецПроцедуры

&НаКлиенте
Процедура ОдобреноГенеральнымНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СформироватьГенеральных();    
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		СтандартнаяОбработка = Ложь;
	    ДанныеВыбора = СформироватьСотрудников()
КонецПроцедуры



&НаСервере
Функция  СформироватьРуководителей()
	МассивРуководителей = Новый Массив;
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000011"));
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000036"));
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000008"));
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000005"));
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000021"));
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000067"));
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000079"));
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000010"));
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000023"));
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000045"));
	МассивРуководителей.Добавить(Справочники.ДолжностиПредприятия.НайтиПоКоду("000000020"));
	
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	                |	ДолжностиСотрудниковСрезПоследних.Сотрудник КАК Сотрудник
	                |ИЗ
	                |	РегистрСведений.ДолжностиСотрудников.СрезПоследних КАК ДолжностиСотрудниковСрезПоследних
	                |ГДЕ
	                |	(ДолжностиСотрудниковСрезПоследних.Должность В(&Должность)
	                |	И ДолжностиСотрудниковСрезПоследних.ТипДоговора <> &ТипДоговора)
	                |	ИЛИ ДолжностиСотрудниковСрезПоследних.Сотрудник = &Сотрудник";
	Запрос.УстановитьПараметр("Должность", МассивРуководителей);
	Запрос.УстановитьПараметр("ТипДоговора", Справочники.ТипыКадровыхДоговоров.НайтиПоКоду("000000004"));
	Запрос.УстановитьПараметр("Сотрудник", Справочники.Сотрудники.НайтиПоКоду("000000029"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Руководители = Новый СписокЗначений;
	пока выборка.Следующий() цикл
		
		Руководители.Добавить(выборка.Сотрудник);
	КонецЦикла;
	Возврат Руководители;
	
КонецФункции


&НаСервере
Функция  СформироватьГенеральных()
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	|	ДолжностиСотрудниковСрезПоследних.Сотрудник КАК Сотрудник
	|ИЗ
	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних КАК ДолжностиСотрудниковСрезПоследних
	|ГДЕ
	|	ДолжностиСотрудниковСрезПоследних.Должность = &Должность";
	Запрос.УстановитьПараметр("Должность", Справочники.ДолжностиПредприятия.НайтиПоКоду("000000072"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Генеральные = Новый СписокЗначений;
	пока выборка.Следующий() цикл
		
		Генеральные.Добавить(выборка.Сотрудник);
	КонецЦикла;
	Возврат Генеральные;
	
КонецФункции


&НаСервере
Функция  СформироватьСотрудников()
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	                |	ДолжностиСотрудниковСрезПоследних.Сотрудник КАК Сотрудник
	                |ИЗ
	                |	РегистрСведений.ДолжностиСотрудников.СрезПоследних КАК ДолжностиСотрудниковСрезПоследних
	                |ГДЕ
	                |	ДолжностиСотрудниковСрезПоследних.Должность <> ЗНАЧЕНИЕ(Справочник.должностиПредприятия.ПустаяСсылка)
	                |
	                |УПОРЯДОЧИТЬ ПО
	                |	ДолжностиСотрудниковСрезПоследних.Сотрудник.Наименование";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Сотрудники = Новый СписокЗначений;
	пока выборка.Следующий() цикл
		
		Сотрудники.Добавить(выборка.Сотрудник);
	КонецЦикла;
	Возврат Сотрудники;
	
КонецФункции


&НаСервере
Процедура РассчётОтсутствия()
	//РазницаВДнях = ((НачалоДня(Объект.ДатаКон) - НачалоДня(Объект.ДатаНач))+1) / (60 * 60 * 24);
	//Если ЗначениеЗаполнено(Объект.ДатаНач) и  ЗначениеЗаполнено(Объект.ДатаКон) Тогда 
	//	Объект.ЧасыОтсутствия = 8*РазницаВДнях;
	//КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ДатаНачПриИзменении(Элемент)
	РассчётОтсутствия();
КонецПроцедуры


&НаКлиенте
Процедура ДатаКонПриИзменении(Элемент)
	РассчётОтсутствия();
КонецПроцедуры

