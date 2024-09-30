#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	//Если Параметры.Сотрудник  <> Справочники.Сотрудники.ПустаяСсылка() Тогда
	//	Объект.Сотрудник = Параметры.Сотрудник;
	//КонецЕсли;
	доступностьОтделов();
	заполнениеСпискаЦФО();
   // заполнениеСпискаОтделов();
    заполнениеСпискаДолжностей();
	Получитькомпоненту(); 
	Элементы.QRКод.РазмерКартинки = РазмерКартинки.АвтоРазмер;
	
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
 Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
 	ПередЗаписьюНаСервере();
 КонецПроцедуры

&НаСервере
 Процедура ПередЗаписьюНаСервере()
 	
 	///+ТатарМА 27.09.2024
 	Если Объект.Вакансия <> Справочники.ВакансииКампании.ПустаяСсылка() И Объект.Вакансия.Статус = Истина И Объект.Ссылка.Проведен Тогда
 		ОбъектВакансии = Справочники.ВакансииКампании.НайтиПоКоду(Объект.Вакансия.Код).ПолучитьОбъект();
 		ОбъектВакансии.ДатаЗакрытия = Объект.Дата;//ТекущаяДатаСеанса();
 		ОбъектВакансии.Статус = Ложь;
 		ОбъектВакансии.Записать();
 	КонецЕсли;
 	///-ТатарМА 27.09.2024
 	
 КонецПроцедуры

 
 &НаКлиенте
Функция ОбновитьФормуСписка()
	 //++Мазин 22.05.24
	Попытка 
	СтруктураРезультатов = ЗапросСотрудникиВСправочникеПодразделения();
	СсылкаНаОбъект = СтруктураРезультатов.СсылкаПодразделение;
	Форма1 = ПолучитьФорму("Справочник.Подразделения.Форма.ФормаЭлемента", Новый Структура("Ключ", СсылкаНаОбъект));
	Форма1.Записать();
	Исключение
	КонецПопытки;
	СсылкаНаОбъект = Объект.Отдел;
	Форма = ПолучитьФорму("Справочник.Подразделения.Форма.ФормаЭлемента", Новый Структура("Ключ", СсылкаНаОбъект));
	Форма.Записать();
	
	СсылкаНаОбъект= СсылкаОргструктура();
	Форма2 = ПолучитьФорму("Справочник.Подразделения.Форма.ФормаЭлемента", Новый Структура("Ключ", СсылкаНаОбъект));
	Форма2.Записать();
 //--Мазин 22.05.24
КонецФункции
 
&НаСервере
 Функция ЗапросСотрудникиВСправочникеПодразделения()
 //++Мазин 14.05.24

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
 
 Запрос.УстановитьПараметр("Ссылка", Объект.Сотрудник);
 
 РезультатЗапроса = Запрос.Выполнить();
 
 ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
 СтруктураРезультатов = Новый Структура;
 
 
 Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
 СтруктураРезультатов.Вставить("СсылкаПодразделение",ВыборкаДетальныеЗаписи.СсылкаПодразделение );	
 СтруктураРезультатов.Вставить("ПользовательСотр",ВыборкаДетальныеЗаписи.ПользовательСотр );
 КонецЦикла; 	
 	 
 		Если СтруктураРезультатов.Свойство("СсылкаПодразделение") Тогда
   			 	Если СтруктураРезультатов.СсылкаПодразделение <> Объект.Отдел  Тогда	
 					УдолитьСотрудникаВСправочникеПодразделения(СтруктураРезультатов);
 					ДобавитьСотрудникаВСправочникеПодразделения(СтруктураРезультатов);
   			 	КонецЕсли;	
 		Иначе ДобавитьСотрудникаВСправочникеПодразделения(СтруктураРезультатов); 
 		КонецЕсли;	
Возврат СтруктураРезультатов; 
 //--Мазин 14.05.24
 КонецФункции

&НаСервере
 Процедура УдолитьСотрудникаВСправочникеПодразделения(СтруктураРезультатов)
 //++Мазин 15.05.24
 СсылкаНаОбъект = СтруктураРезультатов.СсылкаПодразделение;
 ОбъектУчастники = СсылкаНаОбъект.ПолучитьОбъект(); 

 	 			Индекс = ОбъектУчастники.Участники.Количество() - 1;
				Пока Индекс >= 0 Цикл
    			Если ОбъектУчастники.Участники[Индекс].Сотрудник = СтруктураРезультатов.ПользовательСотр Тогда
    				ОбъектУчастники.Участники.Удалить(Индекс);
    				ОбъектУчастники.Записать();
    			КонецЕсли;
    				Индекс = Индекс - 1;
				КонецЦикла;

 КонецПроцедуры

 &НаСервере
 Процедура ДобавитьСотрудникаВСправочникеПодразделения(СтруктураРезультатов)
 //++Мазин 16.05.24

 Запрос = Новый Запрос;
 Запрос.Текст =
 	"ВЫБРАТЬ
 	|	Сотрудники.Пользователь КАК СотрудникПользователь
 	|ИЗ
 	|	Справочник.Сотрудники КАК Сотрудники
 	|ГДЕ
 	|	Сотрудники.Ссылка = &Ссылка";
 
 Запрос.УстановитьПараметр("Ссылка", Объект.Сотрудник);
 
 РезультатЗапроса = Запрос.Выполнить();
 
 ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
 
 Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
 	СотрудникПользователь = ВыборкаДетальныеЗаписи.СотрудникПользователь;
 КонецЦикла;
 

 СсылкаНаОбъект = Объект.Отдел;
 ОбъектУчастники = СсылкаНаОбъект.ПолучитьОбъект();
НоваяСтрока =ОбъектУчастники.Участники.Добавить(); 
НоваяСтрока.Сотрудник = СотрудникПользователь; 
ОбъектУчастники.Записать();

 КонецПроцедуры

&НаСервере
Процедура Получитькомпоненту()
	ТекстОшибки = "";
	
	Штрихкод =  ГенераторШтрихКода.ПолучитьКомпонентуШтрихКодирования(ТекстОшибки); 
	Штрихкод.Ширина = 250; 
	Штрихкод.Высота = 250;
	Штрихкод.ТипКода = 16;
	Штрихкод.УголПоворота = 0;
	Штрихкод.ЗначениеКода = "{ ""id_doc"":"+ """" + Объект.Номер + """" + ",""type"":" +" ""КадровыйПриказ""}";
	Штрихкод.ПрозрачныйФон = Истина;
	Штрихкод.ОтображатьТекст = Ложь;
	
	ДвоичныйШтрихКод = штрихкод.ПолучитьШтрихКод();
	КартинкаШтрихКод = Новый Картинка(ДвоичныйШтрихКод,Истина);
	
	QRкод = ПоместитьВоВременноеХранилище(КартинкаШтрихКод,УникальныйИдентификатор);
	//возврат истина;
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
//++Мазин 16-05-24
	ОбновитьФормуСписка();
	//ЗапросСотрудникиВСправочникеПодразделения();
//--Мазин 16-05-24
	
	ПослеЗаписиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере()

	///+ТатарМА 27.09.2024
	ЗаписьВРегистреСведений 			= РегистрыСведений.АналитикаВакансий.СоздатьМенеджерЗаписи();
	ЗаписьВРегистреСведений.Вакансия 	= Объект.Вакансия.Ссылка;
	ЗаписьВРегистреСведений.Прочитать();
		Если ЗаписьВРегистреСведений.Выбран() И ЗаписьВРегистреСведений.КадровыйПриказ = Документы.КадровыйПриказ.ПустаяСсылка() Тогда
			ЗаписьВРегистреСведений.ДатаЗакрытия 	= Объект.Дата;
			ЗаписьВРегистреСведений.КадровыйПриказ 	= Объект.Ссылка;
			ЗаписьВРегистреСведений.Сотрудник 		= Объект.Сотрудник;
			ЗаписьВРегистреСведений.ПериодПоиска 	= РаботаСДокументамиАналитикаВызовСервера.ПолучитьРазницуДат(Объект.Вакансия.ДатаСоздания, Объект.Вакансия.ДатаЗакрытия);
			ЗаписьВРегистреСведений.Записать();
		КонецЕсли;
	///-ТатарМА 27.09.2024
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Справочник.Подразделения.Форма.ФормаВыбора" Тогда
		Элементы.Сотрудники.ТекущиеДанные.Подразделение = ВыбранноеЗначение;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти



#Область ОбработчикиСобытийЭлементовШапкиФормы


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Сотрудники

&НаКлиенте
Процедура СотрудникиПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//ПараметрыОткрытия = Новый Структура();
	//ПараметрыОткрытия.Вставить("ЦФО", Объект.ЦФО);
	//ПараметрыОткрытия.Вставить("ТекущаяСтрока", Элементы.Сотрудники.ТекущиеДанные.Подразделение);
	//
	//ОткрытьФорму("Справочник.Подразделения.Форма.ФормаВыбора", ПараметрыОткрытия, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры




#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		
		Элементы.Сотрудники.ТекущиеДанные.Дата = Объект.Дата;
		
	КонецЕсли;
	
КонецПроцедуры


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

&НаСервере
Процедура заполнениеСпискаЦФО()
	запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Подразделения.Ссылка КАК Ссылка,
	               |	Подразделения.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.Подразделения КАК Подразделения
	               |ГДЕ
	               |	Подразделения.Город = &Город";
	Запрос.УстановитьПараметр("Город",Объект.Город);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Элементы.ЦФО.СписокВыбора.Очистить();
	
	Пока Выборка.Следующий() Цикл
		Элементы.ЦФО.СписокВыбора.Добавить(Выборка.ссылка,Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура заполнениеСпискаОтделов()
	запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Подразделения.Ссылка КАК Ссылка,
	               |	Подразделения.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.Подразделения КАК Подразделения
	               |ГДЕ
	               |	Подразделения.Родитель = &Родитель";
	Запрос.УстановитьПараметр("Родитель",Объект.ЦФО);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Элементы.Отдел.СписокВыбора.Очистить();
	
	Пока Выборка.Следующий() Цикл
		Элементы.Отдел.СписокВыбора.Добавить(Выборка.ссылка,Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура заполнениеСпискаДолжностей()
	запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДолжностиПредприятия.Ссылка КАК Ссылка,
	|	ДолжностиПредприятия.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Подразделения.Должности КАК ПодразделенияДолжности
	|		Внутреннее СОЕДИНЕНИЕ Справочник.ДолжностиПредприятия КАК ДолжностиПредприятия
	|		ПО ПодразделенияДолжности.Должность = ДолжностиПредприятия.Ссылка
	|ГДЕ
	|	 ПодразделенияДолжности.Ссылка = &отдел";
	Запрос.УстановитьПараметр("Отдел",Объект.Отдел);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Элементы.Должность.СписокВыбора.Очистить();
	
	Пока Выборка.Следующий() Цикл
		Элементы.Должность.СписокВыбора.Добавить(Выборка.ссылка,Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура доступностьОтделов()
	//Элементы.ЦФО.Доступность = ЗначениеЗаполнено(Объект.Город);
	//Элементы.Отдел.Доступность = ЗначениеЗаполнено(Объект.ЦфО);
	//Элементы.Должность.Доступность = ЗначениеЗаполнено(Объект.Отдел);
КонецПроцедуры

&НаКлиенте
Процедура ГородПриИзменении(Элемент)
	заполнениеСпискаЦФО();
	доступностьОтделов();
КонецПроцедуры

&НаКлиенте
Процедура ЦФОПриИзменении(Элемент)
	//заполнениеСпискаОтделов();
	доступностьОтделов();
КонецПроцедуры

&НаКлиенте
Процедура ОтделПриИзменении(Элемент)
	заполнениеСпискаДолжностей();
	доступностьОтделов();
КонецПроцедуры


	

#Область СлужебныеПроцедурыИФункции



#КонецОбласти