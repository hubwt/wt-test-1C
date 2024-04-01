
#Область ОбработчикиСобытийФормы



&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеФормой(ЭтаФорма);
	СписокРасходов.Параметры.УстановитьЗначениеПараметра("Контрагент",Объект.ссылка);
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти

#Область ОбработчикиКомандФормы



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаИНН_КПП.Видимость = (Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.дт_ТипыКлиентов.ЮрЛицо"));
	
КонецПроцедуры

#КонецОбласти