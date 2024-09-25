
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.ссылка) тогда 
			СписокПоступлениеДС.Параметры.УстановитьЗначениеПараметра("СсылкаСделка",Объект.Ссылка);
			Объект.СуммаДокументаАренда = ПодсчетСуммыСписокПоступлениеДС();  
	Иначе 	СписокПоступлениеДС.Параметры.УстановитьЗначениеПараметра("СсылкаСделка",Неопределено); 
	КонецЕсли;
	
	Если Объект.ТМЦ.Количество()<>0 Тогда 
		Элементы.СуммаПродажиТМЦ.Видимость = Истина; 
	Иначе 
		Элементы.СуммаПродажиТМЦ.Видимость = ложь; 
	КонецЕсли; 

	СкрытьИлиПоказатьСумму();
	
КонецПроцедуры
&Насервере
Процедура СкрытьИлиПоказатьСумму()
	Если Объект.ВидДохода = Перечисления.ВидыПрочихДоходов.АрендаИмущества ИЛИ  Объект.ВидДохода = Перечисления.ВидыПрочихДоходов.АрендаТМЦ Тогда 
		элементы.СуммаПродажиТМЦ.Видимость = Ложь; 
		Элементы.СуммаДокументаАренда.видимость = Истина;
		Элементы.СуммаПлатежа.Видимость = Истина; 
		Элементы.ТМЦИмущество.Видимость = Истина;
		Элементы.Клиент.Видимость = Истина;
		Элементы.СотрудникКлиент.Видимость = Ложь;  
	иначе элементы.СуммаПродажиТМЦ.Видимость = Истина; 
		Элементы.СуммаДокументаАренда.видимость = Ложь; 
		Элементы.СуммаПлатежа.Видимость = Ложь; 
		Элементы.ТМЦИмущество.Видимость = ложь;
		Элементы.Клиент.Видимость = Ложь;
		Элементы.СотрудникКлиент.Видимость = Истина; 
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ТМЦПриАктивизацииСтроки(Элемент)
	Если Объект.ТМЦ.Количество()<>0 Тогда 
		ТекДанные = Элементы.ТМЦ.ТекущиеДанные; 
		СписокИндНомер.Параметры.УстановитьЗначениеПараметра("Владелец",ТекДанные.Наименование);	
		Иначе
		СписокИндНомер.Параметры.УстановитьЗначениеПараметра("Владелец", Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДоходаПриИзменении(Элемент)
	СкрытьИлиПоказатьСумму(); 
КонецПроцедуры



&НаКлиенте
Процедура ТМЦИнвентарныйНомерПриИзменении(Элемент)
ТекДанные = Элементы.ТМЦ.ТекущиеДанные; 
Структура = ТМЦИнвентарныйНомерПриИзмененииНаСервере(ТекДанные.ИнвентарныйНомер);
ТекДанные.Стоимость = Структура.Стоимость; 
ТекДанные.Код = Структура.Код;  
КонецПроцедуры

&НаКлиенте
Процедура ТМЦКоличествоПриИзменении(Элемент)
	ТекДанные = Элементы.ТМЦ.ТекущиеДанные;
	ТекДанные.Сумма = ТекДанные.Стоимость * ТекДанные.Количество; 
КонецПроцедуры

&НаКлиенте
Процедура ТМЦСтоимостьПриИзменении(Элемент)
	ТекДанные = Элементы.ТМЦ.ТекущиеДанные;
	ТекДанные.Сумма = ТекДанные.Стоимость * ТекДанные.Количество; 
КонецПроцедуры



&НаСервере
Функция ТМЦИнвентарныйНомерПриИзмененииНаСервере(Наименование)
Запрос = Новый Запрос;
Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнвентарныеНомера.Стоимость,
	|	ИнвентарныеНомера.Код
	|ИЗ
	|	Справочник.ИнвентарныеНомера КАК ИнвентарныеНомера
	|ГДЕ
	|	ИнвентарныеНомера.Наименование = &Наименование";

Запрос.УстановитьПараметр("Наименование", Наименование);

РезультатЗапроса = Запрос.Выполнить();

ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
Структура = Новый Структура; 
Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Структура.Вставить("Стоимость",ВыборкаДетальныеЗаписи.Стоимость );
	Структура.Вставить("Код",ВыборкаДетальныеЗаписи.Код );
КонецЦикла;
Возврат Структура; 
КонецФункции
&НаКлиенте

Процедура ТМЦПриИзменении(Элемент)
	Элементы.СуммаПродажиТМЦ.Видимость = Ложь; 
	Если Объект.ТМЦ.Количество()>0 Тогда 
		Элементы.СуммаПродажиТМЦ.Видимость = Истина; 
		Объект.СуммаПродажиТМЦ = 0; 
		Для каждого Строка Из Объект.ТМЦ Цикл 
			Объект.СуммаПродажиТМЦ = Объект.СуммаПродажиТМЦ + Строка.Сумма;
		КонецЦикла; 
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ТМЦНаименованиеПриИзменении(Элемент)
		Если Объект.ТМЦ.Количество()>0 Тогда 
		ТекДанные = Элементы.ТМЦ.ТекущиеДанные; 
		СписокИндНомер.Параметры.УстановитьЗначениеПараметра("Владелец",ТекДанные.Наименование);
		Иначе
		СписокИндНомер.Параметры.УстановитьЗначениеПараметра("Владелец", Неопределено);	
	КонецЕсли;
КонецПроцедуры
// Подсчет суммы динамического списка с пиходоми денег на счет 
Функция ПодсчетСуммыСписокПоступлениеДС() 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПриходДенегНаСчет.СуммаДокумента КАК СуммаДокумента
		|ИЗ
		|	Документ.ПриходДенегНаСчет КАК ПриходДенегНаСчет
		|ГДЕ
		|	ПриходДенегНаСчет.Сделка = &СсылкаСделка";
	
	Запрос.УстановитьПараметр("СсылкаСделка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Сумма = 0; 
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сумма= Сумма +  ВыборкаДетальныеЗаписи.СуммаДокумента; 
	КонецЦикла;
	
	Возврат Сумма;
КонецФункции; 




