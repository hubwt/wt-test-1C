

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбновитьСтоимость();
	ОбновитьПредставлениеКатегории();
	
	ОбновитьВычисляемыеДанные();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступноИзменениеЦены = РольДоступна("дт_ИзменениеЦенНаРаботы") 
		ИЛИ Пользователи.ЭтоПолноправныйПользователь();
		
	
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьВычисляемыеДанные();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(Объект.НаименованиеПолное) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КатегорияРаботПриИзменении(Элемент)
	
	ОбновитьСтоимость();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяВыполненияПриИзменении(Элемент)
	ОбновитьСтоимость();
КонецПроцедуры

&НаКлиенте
Процедура СтоимостьПриИзменении(Элемент)
	Если Нормочас <> 0 И Стоимость <> 0 Тогда
		Объект.ВремяВыполнения = Стоимость / Нормочас;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КатегорияЗапчастейПриИзменении(Элемент)
	ОбновитьПредставлениеКатегории();
КонецПроцедуры

&НаКлиенте
Процедура ВремяВыполненияСекПриИзменении(Элемент)
	Объект.ВремяВыполнения = дт_ОбщегоНазначенияКлиентСервер.ВремяВЧасы(ВремяВыполненияСек);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти

#Область ОбработчикиКомандФормы



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСтоимость()

	Если ЗначениеЗаполнено(Объект.КатегорияРабот) Тогда
		Нормочас = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.КатегорияРабот, "Нормочас");
	Иначе
		Нормочас = 0;
	КонецЕсли;
	Элементы.Стоимость.Подсказка = ?(Нормочас = 0, "Определяется по нормочасу", "Нормочас " + Формат(Нормочас, "ЧДЦ=2; ЧГ=3,0"));
	Стоимость = Нормочас * Объект.ВремяВыполнения;

КонецПроцедуры // ОбновитьСтоимость()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ОбновитьПредставлениеКатегории()

	ПредставлениеКатегории = "";
	Если ЗначениеЗаполнено(Объект.КатегорияЗапчастей) Тогда
		ПредставлениеКатегории = дт_Автосервис.ПолучитьПредставлениеКатегории(Объект.КатегорияЗапчастей);
	КонецЕсли;

КонецПроцедуры // ОбновитьПредставлениеКатегории()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Элементы.Стоимость.Доступность = Форма.Нормочас <> 0;
	
	Элементы.ВремяВыполненияСек.Видимость = Ложь; // Форма.ПолучитьФункциональнуюОпциюФормы("дт_ИспользоватьЗаказНарядВнутренний");
	Элементы.ВремяВыполнения.Видимость = НЕ Элементы.ВремяВыполненияСек.Видимость;
	
	Элементы.Стоимость.ТолькоПросмотр = НЕ Форма.ДоступноИзменениеЦены;
	 
КонецПроцедуры // УправлениеФормой()


&НаСервере
Процедура ОбновитьВычисляемыеДанные()
	ВремяВыполненияСек = дт_ОбщегоНазначенияКлиентСервер.ЧасыВоВремя(Объект.ВремяВыполнения);
КонецПроцедуры





#КонецОбласти





