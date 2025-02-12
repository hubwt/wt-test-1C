
#Область ОбработчикиСобытийФормы



#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьТипВладельца();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ОбновитьТипВладельца();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	
	ОбновитьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	
	ОбновитьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	
	ОбновитьНаименование();
	
КонецПроцедуры



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти

#Область ОбработчикиКомандФормы



#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.Владелец.Заголовок = ?(Форма.ТипВладельца = "Организация", "Организация", "Контрагент");
	

КонецПроцедуры // УправлениеФормой()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ОбновитьТипВладельца()

	ТипВладельца = Объект.Владелец.Метаданные().Имя;
	

КонецПроцедуры // ОбновитьТипВладельца()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Процедура ОбновитьНаименование()

	Слова = Новый Массив();
	Слова.Добавить(Объект.Фамилия);
	Слова.Добавить(Объект.Имя);
	Слова.Добавить(Объект.Отчество);
	
	ФИО = "";
	Для каждого Слово Из Слова Цикл
	
		Если Не ПустаяСтрока(Слово) Тогда
			ФИО = ФИО + Слово + " ";
		КонецЕсли;
	
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(ФИО);
	
	Объект.Наименование = ФИО;

КонецПроцедуры // ОбновитьНаименование()



#КонецОбласти