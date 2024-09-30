




#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	ТекДанные = Элементы.Сотрудники.ТекущиеДанные;
	Вакансия = ПолучитьВакансиюСотрудника(ТекДанные.Сотрудник);
	ТекДанные.Вакансия = Вакансия;
КонецПроцедуры

&НаСервере
 Функция ЗапросСотрудникиВСправочникеПодразделения()
 //++Мазин 21.05.24
Для Каждого Сотрудник ИЗ Объект.Сотрудники Цикл 
	Сотр = Сотрудник.Сотрудник;
	КонецЦикла; 
 Запрос = Новый Запрос;
 Запрос.Текст =
 	"ВЫБРАТЬ
 	|	Сотрудники.Пользователь КАК ПользовательСотр,
 	|	Подразделения.Ссылка КАК СсылкаПодразделение
 	|ИЗ
 	|	Справочник.Подразделения КАК Подразделения
 	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
 	|		ПО Подразделения.Участники.Сотрудник = Сотрудники.Пользователь
 	|ГДЕ
 	|	Сотрудники.Ссылка = &Ссылка";
 
 Запрос.УстановитьПараметр("Ссылка", Сотр);
 
 РезультатЗапроса = Запрос.Выполнить();
 
 ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
 СтруктураРезультатов = Новый Структура;
 
 
 Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
 СтруктураРезультатов.Вставить("СсылкаПодразделение",ВыборкаДетальныеЗаписи.СсылкаПодразделение );	
 СтруктураРезультатов.Вставить("ПользовательСотр",ВыборкаДетальныеЗаписи.ПользовательСотр );
 КонецЦикла; 	
 
 Если СтруктураРезультатов.Свойство("СсылкаПодразделение") Тогда
 СсылкаНаОбъект = СтруктураРезультатов.СсылкаПодразделение;
 ОбъектУчастники = СсылкаНаОбъект.ПолучитьОбъект(); 

 	 			Индекс = ОбъектУчастники.Участники.Количество() - 1;
				Пока Индекс >= 0 Цикл
    			Если ОбъектУчастники.Участники[Индекс].Сотрудник = СтруктураРезультатов.ПользовательСотр Тогда
    				ОбъектУчастники.Участники.Удалить(Индекс);
    				ОбъектУчастники.Записать();
    				Возврат СсылкаНаОбъект; 
    			КонецЕсли;
    				Индекс = Индекс - 1;
				КонецЦикла;
Возврат СсылкаНаОбъект; 				
КонецЕсли;

 //--Мазин 21.05.24
 КонецФункции

 &НаСервере
 Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
 	
 	///+ТатарМА 27.09.2024
 	Для Каждого СтрокаТЧ Из Объект.Сотрудники Цикл
 		ЗаписьВРегистреСведений 			= РегистрыСведений.АналитикаВакансий.СоздатьМенеджерЗаписи();
		ЗаписьВРегистреСведений.Вакансия 	= СтрокаТЧ.Вакансия;
		ЗаписьВРегистреСведений.Прочитать();
		Если ЗаписьВРегистреСведений.Выбран() И ЗаписьВРегистреСведений.Увольнение = Документы.УвольненияСотрудников.ПустаяСсылка() Тогда
			ЗаписьВРегистреСведений.ДатаУвольнения 	= Объект.Дата;
			ЗаписьВРегистреСведений.Увольнение 		= Объект.Ссылка;
			ЗаписьВРегистреСведений.ПериодРаботы 	= РаботаСДокументамиАналитикаВызовСервера.ПолучитьРазницуДат(СтрокаТЧ.Вакансия.ДатаСоздания, СтрокаТЧ.Вакансия.ДатаЗакрытия);
			ЗаписьВРегистреСведений.Записать();
		КонецЕсли;
 	КонецЦикла;
 	///-ТатарМА 27.09.2024
 	
 КонецПроцедуры


&НаСервере
Функция СсылкаОргструктура()
//++МазинЕС 23.05.24	
 Запрос = Новый Запрос;
 Запрос.Текст =
 	"ВЫБРАТЬ
 	|	Подразделения.Ссылка КАК Ссылка
 	|ИЗ
 	|	Справочник.Подразделения КАК Подразделения
 	|ГДЕ
 	|	Подразделения.Код = &Код";
 Запрос.УстановитьПараметр("Код","000000105");
 РезультатЗапроса = Запрос.Выполнить();
 
 ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
 
 Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
 	Возврат ВыборкаДетальныеЗаписи.Ссылка;
 КонецЦикла;
//++МазинЕС 23.05.24
 КонецФункции

&НаКлиенте
Функция ОбновитьФормуСписка()
	 //++Мазин 21.05.24
	СсылкаНаОбъект = ЗапросСотрудникиВСправочникеПодразделения();
	Форма = ПолучитьФорму("Справочник.Подразделения.Форма.ФормаЭлемента", Новый Структура("Ключ", СсылкаНаОбъект));
	Форма.Записать();

	СсылкаНаОбъект= СсылкаОргструктура();
	Форма2 = ПолучитьФорму("Справочник.Подразделения.Форма.ФормаЭлемента", Новый Структура("Ключ", СсылкаНаОбъект));
	Форма2.Записать();
 //--Мазин 21.05.24
КонецФункции
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	//++Мазин 
	ОбновитьФормуСписка();
	//--Мазин 
КонецПроцедуры





#КонецОбласти








#Область ОбработчикиСобытийЭлементовШапкиФормы


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Сотрудники


&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		
		Элементы.Сотрудники.ТекущиеДанные.Дата = Объект.Дата;
		
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти

#Область ОбработчикиКомандФормы



// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьВакансиюСотрудника(Сотрудник)
	
///+ТатарМА 27.09.2024
Запрос = Новый Запрос;
Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	АналитикаВакансий.Вакансия КАК Вакансия
	|ИЗ
	|	РегистрСведений.АналитикаВакансий КАК АналитикаВакансий
	|ГДЕ
	|	АналитикаВакансий.Сотрудник = &Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	АналитикаВакансий.ДатаСоздания УБЫВ";

Запрос.УстановитьПараметр("Сотрудник", Сотрудник);

РезультатЗапроса = Запрос.Выполнить().Выбрать();

РезультатЗапроса.Следующий();

Результат = РезультатЗапроса.Вакансия;

Возврат Результат;
///-ТатарМА 27.09.2024

КонецФункции

#КонецОбласти