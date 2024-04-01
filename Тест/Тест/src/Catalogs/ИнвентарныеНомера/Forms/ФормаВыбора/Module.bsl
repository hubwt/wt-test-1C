
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//ТМЦ = Неопределено;
	//Склад = Неопределено;
	////Параметры.Свойство("Склад", Склад);
	//Если Параметры.Свойство("Отбор") Тогда
	//	Параметры.Отбор.Свойство("Владелец", ТМЦ);
	//КонецЕсли;	
	//
	Список.Параметры.УстановитьЗначениеПараметра("ДатаОстатков", ТекущаяДатаСеанса());
	////Список.Параметры.УстановитьЗначениеПараметра("Склад", Склад);
	//Список.Параметры.УстановитьЗначениеПараметра("Номенклатура", ТМЦ);

	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	
	///+ГомзМА 16.05.2023
	Попытка
		
		Если ЭтаФорма.ВладелецФормы.ИмяФормы = "Документ.ПеремещениеТМЦВорктрак.Форма.ФормаДокумента" ИЛИ
			 ЭтаФорма.ВладелецФормы.ИмяФормы = "Документ.СписаниеТМЦВорктрак.Форма.ФормаДокумента"	Тогда
			
			ЗаменитьТекстЗапросаНаСервере();
			
		КонецЕсли;
		
	Исключение
	
	КонецПопытки;
	///-ГомзМА 16.05.2023
	
КонецПроцедуры


&НаСервере
Процедура ЗаменитьТекстЗапросаНаСервере()

	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "СкладСнабжение", "Ворктрак");

КонецПроцедуры


&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Перемен = 1;
КонецПроцедуры


&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	///+ГомзМА 19.05.2023
	Если НЕ ЭтаФорма.ВладелецФормы = Неопределено Тогда
		Структура = Новый Структура;
		Структура.Вставить("Ссылка", Элементы.Список.ТекущиеДанные.Ссылка);
		Структура.Вставить("Команда","ПравильныйПоиск");	
				
		Форма = ЭтаФорма.ВладелецФормы;
		ОповеститьОВыборе(Структура);
	КонецЕсли;
	///+ГомзМА 19.05.2023

		
КонецПроцедуры


