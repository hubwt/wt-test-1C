
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Фильтр = 1;
	ДатаНачала = ДобавитьМесяц(ТекущаяДата(), -12);
	ДатаОкончания = КонецДня(ТекущаяДата());
	СписокТовараКоторыНужноСписать.Параметры.УстановитьЗначениеПараметра("ДатаНачала", ДатаНачала);
	СписокТовараКоторыНужноСписать.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", ДатаОкончания);
	СписокТовараКоторыНужноСписать.Параметры.УстановитьЗначениеПараметра("Склад", Справочники.Склады.НайтиПоКоду("000000002"));
КонецПроцедуры

&НаКлиенте
Процедура ФильтрПриИзменении(Элемент)
	Если Фильтр = 1 Тогда
		СписокТовараКоторыНужноСписать.Параметры.УстановитьЗначениеПараметра("Склад", ПолучитьСклад(1));
	ИначеЕсли Фильтр = 2 Тогда 
		СписокТовараКоторыНужноСписать.Параметры.УстановитьЗначениеПараметра("Склад", ПолучитьСклад(2));
	ИначеЕсли Фильтр = 3 Тогда 
		СписокТовараКоторыНужноСписать.Параметры.УстановитьЗначениеПараметра("Склад", ПолучитьСклад(3));
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСклад(НомерФильтра)
	Если НомерФильтра = 1 Тогда
		Возврат Справочники.Склады.НайтиПоКоду("000000002");
	ИначеЕсли НомерФильтра = 2 Тогда 
		Возврат Справочники.Склады.НайтиПоКоду("000000005");
	ИначеЕсли НомерФильтра = 2 Тогда 
		Возврат Справочники.Склады.НайтиПоКоду("000000008");
	КонецЕсли;
КонецФункции

