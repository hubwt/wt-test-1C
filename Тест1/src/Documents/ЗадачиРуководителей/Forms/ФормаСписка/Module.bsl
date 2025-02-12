

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьУсловноеОформление();
	
	Период.ДатаНачала = НачалоМесяца(ТекущаяДата());
	Период.ДатаОкончания = КонецМесяца(ТекущаяДата());
	
	ЗаполнитьСписки();
	
	ОбновитьСписок();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры


#КонецОбласти



#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура Статус1ПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура СтатусыАвтораПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ОбновитьСписок();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список


&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	///+ГомзМА 30.06.2023
	ТекущийПользователь = ПолучитьТекущегоПользователя();
	ПользовательСодержитРоли = ПользовательСодержитРоли();
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если Элементы.Список.ТекущиеДанные <> Неопределено И (ТекущийПользователь = ТекДанные.Исполнитель ИЛИ ПользовательСодержитРоли) Тогда
		Элементы.СделатьПервым.Доступность 		= Истина;
		Элементы.СделатьПоследним.Доступность 	= Истина;
		Элементы.ПовыситьПриоритет.Доступность 	= Истина;
		Элементы.ПонизитьПриоритет.Доступность 	= Истина;
	Иначе
		Элементы.СделатьПервым.Доступность 		= Ложь;
		Элементы.СделатьПоследним.Доступность 	= Ложь;
		Элементы.ПовыситьПриоритет.Доступность 	= Ложь;
		Элементы.ПонизитьПриоритет.Доступность 	= Ложь;
	КонецЕсли;
	///-ГомзМА 30.06.2023
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура УстановитьУсловноеОформление()
	
	//Список.УсловноеОформление.Элементы.Очистить();
	//
	//// Выполнено
	//ЭлементУО = Список.УсловноеОформление.Элементы.Добавить();
	//
	//ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
	//"Выполнено", ВидСравненияКомпоновкиДанных.Равно, Истина);
	//ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ДобавленныйРеквизитФон);
	
	
	
КонецПроцедуры // УстановитьУсловноеОформление()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ОбновитьСписок()
	Текст = "ВЫБРАТЬ
	        |	ДокументЗадача.Ссылка КАК Ссылка,
	        |	ДокументЗадача.ПометкаУдаления КАК ПометкаУдаления,
	        |	ДокументЗадача.Номер КАК Номер,
	        |	ДокументЗадача.Дата КАК Дата,
	        |	ДокументЗадача.Проведен КАК Проведен,
	        |	ДокументЗадача.Наименование КАК Наименование,
	        |	ВЫРАЗИТЬ(ДокументЗадача.Описание КАК СТРОКА(256)) КАК Описание,
	        |	ДокументЗадача.Выполнено КАК Выполнено,
	        |	ДокументЗадача.МоментВремени КАК МоментВремени,
	        |	ДокументЗадача.Проект КАК Проект,
	        |	ДокументЗадача.Ответственный КАК Ответственный,
	        |	ДокументЗадача.Исполнитель КАК Исполнитель,
	        |	ДокументЗадача.Подразделение КАК Подразделение,
	        |	ДокументЗадача.ДатаНачалаПлан КАК ДатаНачалаПлан,
	        |	ДокументЗадача.ДатаОкончанияПлан КАК ДатаОкончанияПлан,
	        |	ДокументЗадача.ДатаОкончанияФакт КАК ДатаОкончанияФакт,
	        |	ДокументЗадача.ВремяВыполнения КАК ВремяВыполнен,
	        |	ДокументЗадача.Статус КАК Статус,
	        |	ДокументЗадача.СтатусАвтора КАК СтатусАвтора,
	        |	ДокументЗадача.Контроль КАК Контроль,
	        |	ДокументЗадача.ОценкаЗадач КАК ОценкаЗадач,
	        |	ДокументЗадача.ПлановыйСрокВыполнения КАК ПлановыйСрокВыполнения,
	        |	ДокументЗадача.ЗадачаСПортала КАК ЗадачаСПортала,
	        |	РАЗНОСТЬДАТ(ДокументЗадача.ДатаНачалаПлан, ДокументЗадача.ДатаОкончанияПлан, ДЕНЬ)+1 КАК ВремяВыполнения
	        |ИЗ
	        |	Документ.ЗадачиРуководителей КАК ДокументЗадача";
	
	Если ЗначениеЗаполнено(Период) Тогда	
		СписокАктивных.Параметры.УстановитьЗначениеПараметра("ДатаНач",Период.ДатаНачала);
		СписокАктивных.Параметры.УстановитьЗначениеПараметра("ДатаКон",Период.ДатаОкончания);
		
		СписокВыполненых.Параметры.УстановитьЗначениеПараметра("ДатаНач",Период.ДатаНачала);
		СписокВыполненых.Параметры.УстановитьЗначениеПараметра("ДатаКон",Период.ДатаОкончания);
		
	Иначе
		СписокАктивных.Параметры.УстановитьЗначениеПараметра("ДатаНач",Дата(2000,01,01));
		СписокАктивных.Параметры.УстановитьЗначениеПараметра("ДатаКон",КонецДня(ТекущаяДата()));
		
		СписокВыполненых.Параметры.УстановитьЗначениеПараметра("ДатаНач",Дата(2000,01,01));
		СписокВыполненых.Параметры.УстановитьЗначениеПараметра("ДатаКон",КонецДня(ТекущаяДата()));
	КонецЕсли;
	
	Все = Новый массив;
	все.Добавить(Истина);
	Все.Добавить(Ложь);
	
	Если Элементы.Проект.СписокВыбора.Количество() < 2 Тогда
		// нет доступа ни к одному проекту
		Если СтрНайти(Список.ТекстЗапроса, "ГДЕ") = 0 Тогда
			Список.ТекстЗапроса = Список.ТекстЗапроса + " ГДЕ ЛОЖЬ";
		КонецЕсли;
		
		Возврат	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Проект) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Проект", 
		Проект, // Значение отбора
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	Иначе
		ДоступныеПроекты = Элементы.Проект.СписокВыбора.ВыгрузитьЗначения();
		//ДоступныеПроекты.Удалить(0);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Проект", 
		ДоступныеПроекты, // Значение отбора
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПроектДашборд) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокВыполненых, 
		"Проект", 
		ПроектДашборд, // Значение отбора
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокАктивных, 
		"Проект", 
		ПроектДашборд, // Значение отбора
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	Иначе
		ДоступныеПроектыДашборд = Элементы.ПроектДашборд.СписокВыбора.ВыгрузитьЗначения();
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокВыполненых, 
		"Проект", 
		ДоступныеПроектыДашборд, // Значение отбора
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокАктивных, 
		"Проект", 
		ДоступныеПроектыДашборд, // Значение отбора
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИсполнительДашборд) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокВыполненых, 
		"Исполнитель", 
		ИсполнительДашборд, // Значение отбора
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокАктивных, 
		"Исполнитель", 
		ИсполнительДашборд, // Значение отбора
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	Иначе
		ДоступныеИсполнители = Элементы.ИсполнительДашборд.СписокВыбора.ВыгрузитьЗначения();
		//ДоступныеПроекты.Удалить(0);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокВыполненых, 
		"Исполнитель", 
		ДоступныеИсполнители, // Значение отбора
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокАктивных, 
		"Исполнитель", 
		ДоступныеИсполнители, // Значение отбора
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АвторИлиИсполнитель) Тогда
	Текст = Текст + Символы.ПС + "ГДЕ ДокументЗадача.Исполнитель = &Исполнитель ИЛИ ДокументЗадача.Ответственный = &Ответственный";
	Список.ТекстЗапроса = Текст;
	Список.Параметры.УстановитьЗначениеПараметра("Исполнитель",АвторИлиИсполнитель);
	Список.Параметры.УстановитьЗначениеПараметра("Ответственный",АвторИлиИсполнитель);
	Иначе
	Список.ТекстЗапроса = текст;
	
	КонецЕсли;

	
	Если ЗначениеЗаполнено(СтатусИсполнителя) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Статус", 
		СтатусИсполнителя, // Значение отбора
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	Иначе
		ДоступныеСтатусы = Элементы.СтатусИсполнителя.СписокВыбора.ВыгрузитьЗначения();
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Статус", 
		ДоступныеСтатусы, // Значение отбора
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(СтатусыАвтора) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"СтатусАвтора", 
		СтатусыАвтора, // Значение отбора
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	Иначе
		ДоступныеСтатусыАвтора = Элементы.СтатусыАвтора.СписокВыбора.ВыгрузитьЗначения();
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"СтатусАвтора", 
		ДоступныеСтатусыАвтора, // Значение отбора
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	КонецЕсли;
	
	Если активные Тогда	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Выполнено", 
		Не Активные, // Значение отбора
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Выполнено", 
		Все, // Значение отбора
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	КонецЕсли;
	
	Если ИгнорироватьПериод Тогда
		
		СписокАктивных.Параметры.УстановитьЗначениеПараметра("ДатаНач",Дата(2000,01,01));
		СписокАктивных.Параметры.УстановитьЗначениеПараметра("ДатаКон",КонецДня(ТекущаяДата()));
		
	Иначе
		СписокАктивных.Параметры.УстановитьЗначениеПараметра("ДатаНач",Период.ДатаНачала);
		СписокАктивных.Параметры.УстановитьЗначениеПараметра("ДатаКон",Период.ДатаОкончания);
		
	КонецЕсли;
	
КонецПроцедуры // ОбновитьСписок()

&НаСервере
Процедура ЗаполнитьСписки()
	
	ЗапросПроекта = Новый Запрос;
	//Если Пользователи.ЭтоПолноправныйПользователь() Тогда
	
	ЗапросПроекта.Текст = 
	"ВЫБРАТЬ
	|	Проекты.Ссылка КАК Ссылка,
	|	Проекты.Представление КАК Представление
	|ИЗ
	|	Справочник.ПроектыРазвития1 КАК Проекты
	|ГДЕ
	|	НЕ Проекты.ПометкаУдаления
	|	И НЕ Проекты.Завершен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	ЗапросИсполнитель = Новый Запрос;
	//Если Пользователи.ЭтоПолноправныйПользователь() Тогда
	
	ЗапросИсполнитель.Текст = 
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Ссылка,
	|	Пользователи.Наименование КАК Представление
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.ПометкаУдаления
	|	И НЕ Пользователи.Недействителен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	//Иначе
	
	//Запрос.Текст = 
	//"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//|	ПроектыУчастники.Ссылка КАК Ссылка,
	//|	ПроектыУчастники.Ссылка.Представление КАК Представление
	//|ИЗ
	//|	Справочник.ПроектыРазвития.Участники КАК ПроектыУчастники
	//|ГДЕ
	//|	ПроектыУчастники.Сотрудник = &Сотрудник
	//|	И НЕ ПроектыУчастники.Ссылка.ПометкаУдаления
	//|	И НЕ ПроектыУчастники.Ссылка.Завершен
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	ПроектыУчастники.Ссылка
	//|АВТОУПОРЯДОЧИВАНИЕ";
	//
	//Запрос.УстановитьПараметр("Сотрудник", Пользователи.ТекущийПользователь());
	
	//КонецЕсли;
	
	Элементы.Проект.СписокВыбора.Очистить();
	Элементы.Проект.СписокВыбора.Добавить(Справочники.ПроектыРазвития1.ПустаяСсылка(), "ВСЕ");
	
	Элементы.ПроектДашборд.СписокВыбора.Очистить();
	Элементы.ПроектДашборд.СписокВыбора.Добавить(Справочники.ПроектыРазвития.ПустаяСсылка(), "ВСЕ");
	
	Элементы.ИсполнительДашборд.СписокВыбора.Очистить();
	Элементы.ИсполнительДашборд.СписокВыбора.Добавить(Справочники.Пользователи.ПустаяСсылка(), "Любой");
	
	Элементы.АвторИлиИсполнитель.СписокВыбора.Очистить();
	Элементы.АвторИлиИсполнитель.СписокВыбора.Добавить(Справочники.Пользователи.ПустаяСсылка(), "Игнорировать");
	
	РезультатЗапросаПроекта 	= ЗапросПроекта.Выполнить();
	РезультатЗапросаИсполнитель = ЗапросИсполнитель.Выполнить();
	
	ВыборкаДетальныеЗаписиПроекта = РезультатЗапросаПроекта.Выбрать();
	ВыборкаДетальныеЗаписиИсполнитель = РезультатЗапросаИсполнитель.Выбрать();
	
	Пока ВыборкаДетальныеЗаписиПроекта.Следующий() Цикл
		
		Элементы.Проект.СписокВыбора.Добавить(ВыборкаДетальныеЗаписиПроекта.Ссылка, ВыборкаДетальныеЗаписиПроекта.Представление);
		Элементы.ПроектДашборд.СписокВыбора.Добавить(ВыборкаДетальныеЗаписиПроекта.Ссылка, ВыборкаДетальныеЗаписиПроекта.Представление);
		
	КонецЦикла;
	
	Пока ВыборкаДетальныеЗаписиИсполнитель.Следующий() Цикл
		
		Элементы.ИсполнительДашборд.СписокВыбора.Добавить(ВыборкаДетальныеЗаписиИсполнитель.Ссылка, ВыборкаДетальныеЗаписиИсполнитель.Представление);
		Элементы.АвторИлиИсполнитель.СписокВыбора.Добавить(ВыборкаДетальныеЗаписиИсполнитель.Ссылка, ВыборкаДетальныеЗаписиИсполнитель.Представление);

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СделатьПервымНаСервере(ТекСтрока)
	
	Проверка = 1;
	Выборка = ПолучитьЗадачи(ТекСтрока,"Возр").Выбрать();
	Выборка.следующий();
	Если Выборка.Приоритет>1 Тогда
		Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача 		 = ТекСтрока.Ссылка;
		Запись.Ответственный = ТекСтрока.Исполнитель;
		Запись.Приоритет     = 1;
		Запись.Записать();
	Иначе
		Если Выборка.Приоритет = ТекСтрока.Приоритет Тогда
			Возврат;
		КонецЕсли;
		
		Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача 		 = Выборка.Задача;
		Запись.Ответственный = Выборка.Ответственный;
		Запись.Приоритет     = Выборка.приоритет + 1;
		Проверка = Проверка+1;
		Запись.Записать();
		Пока Выборка.следующий() Цикл
			Если Выборка.приоритет = Проверка И Выборка.приоритет <= ТекСтрока.Приоритет Тогда
				Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
				Запись.Задача 		 = Выборка.Задача;
				Запись.Ответственный = Выборка.Ответственный;
				Запись.Приоритет     = Выборка.приоритет + 1;
				Запись.Записать();
				Проверка = Проверка+1;
			КонецЕсли;
		КонецЦикла;
		Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача 		 = ТекСтрока.Ссылка;
		Запись.Ответственный = ТекСтрока.Исполнитель;
		Запись.Приоритет     = 1;
		Запись.Записать();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьПервым(Команда)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	СделатьПервымНаСервере(ТекСтрока);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Функция  ПолучитьЗадачи(ТекСтрока,Сорт = "")
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПриоритетыЗадач.Задача КАК Задача,
	|	ПриоритетыЗадач.Ответственный КАК Ответственный,
	|	ПриоритетыЗадач.Приоритет КАК Приоритет
	|ИЗ
	|	РегистрСведений.ПриоритетыЗадач КАК ПриоритетыЗадач
	|ГДЕ
	|	ПриоритетыЗадач.Ответственный = &Ответственный";
	
	Если Сорт = "Убыв" тогда
		Запрос.Текст = Запрос.Текст + Символы.ПС + "упорядочить по"+ Символы.ПС +"Приоритет убыв";
	ИначеЕсли Сорт = "Возр" тогда
		Запрос.Текст = Запрос.Текст + Символы.ПС + "упорядочить по"+ Символы.ПС +"Приоритет ";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ответственный", ТекСтрока.Исполнитель);
	Таблица = Запрос.Выполнить();
	Возврат Таблица;		   
	
КонецФункции

&НаСервере
Процедура СделатьПоследнимНаСервере(ТекСтрока)
	
	Выборка = ПолучитьЗадачи(ТекСтрока, "Убыв").Выбрать();
	Выборка.следующий();
	Проверка = Выборка.Приоритет;
	
	
	Если Выборка.Приоритет = Неопределено Тогда
		Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача 		 = ТекСтрока.Ссылка;
		Запись.Ответственный = ТекСтрока.Исполнитель;
		Запись.Приоритет     = 999;
		Запись.Записать();
	Иначе
		Если Выборка.Приоритет = ТекСтрока.Приоритет Тогда
			Возврат;
		КонецЕсли;
		Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача 		 = ТекСтрока.Ссылка;
		Запись.Ответственный = ТекСтрока.Исполнитель;
		Запись.Приоритет     = Проверка;
		Запись.Записать();
		
		Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача 		 = Выборка.Задача;
		Запись.Ответственный = Выборка.Ответственный;
		Запись.Приоритет     = Выборка.приоритет - 1;
		Проверка = Проверка-1;
		Запись.Записать();
		Пока Выборка.следующий() Цикл
			Если Выборка.приоритет = Проверка И Выборка.Задача <> ТекСтрока.Ссылка Тогда
				Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
				Запись.Задача 		 = Выборка.Задача;
				Запись.Ответственный = Выборка.Ответственный;
				Запись.Приоритет     = Выборка.приоритет - 1;
				Запись.Записать();
				Проверка = Проверка-1;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьПоследним(Команда)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	СделатьПоследнимНаСервере(ТекСтрока);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ПовыситьПриоритет(Команда)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	ПовыситьПриоритетНаСервере(ТекСтрока);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура ПовыситьПриоритетНаСервере(ТекСтрока)
	Если ТекСтрока.Приоритет = 1 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПриоритетыЗадач.Задача КАК Задача,
	|	ПриоритетыЗадач.Ответственный КАК Ответственный,
	|	ПриоритетыЗадач.Приоритет КАК Приоритет
	|ИЗ
	|	РегистрСведений.ПриоритетыЗадач КАК ПриоритетыЗадач
	|ГДЕ
	|	ПриоритетыЗадач.Ответственный = &Ответственный
	|	И (ПриоритетыЗадач.Приоритет = &Приоритет
	|			ИЛИ ПриоритетыЗадач.Приоритет = &Приоритет - 1)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Запрос.УстановитьПараметр("Ответственный", ТекСтрока.Исполнитель);
	Запрос.УстановитьПараметр("Приоритет", ТекСтрока.приоритет);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Попытка
		Выборка.следующий(); 
		Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача 		 = Выборка.Задача;
		Запись.Ответственный = Выборка.Ответственный;
		Запись.Приоритет     = Выборка.приоритет + 1;
		Запись.Записать();
	Исключение
	КонецПопытки;
	Попытка
		Выборка.следующий();
		Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача 		 = Выборка.Задача;
		Запись.Ответственный = Выборка.Ответственный;
		Запись.Приоритет     = Выборка.приоритет - 1;
		Запись.Записать();
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ПонизитьПриоритетНаСервере(ТекСтрока)
	Если ТекСтрока.Приоритет = 999 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПриоритетыЗадач.Задача КАК Задача,
	|	ПриоритетыЗадач.Ответственный КАК Ответственный,
	|	ПриоритетыЗадач.Приоритет КАК Приоритет
	|ИЗ
	|	РегистрСведений.ПриоритетыЗадач КАК ПриоритетыЗадач
	|ГДЕ
	|	ПриоритетыЗадач.Ответственный = &Ответственный
	|	И (ПриоритетыЗадач.Приоритет = &Приоритет
	|			ИЛИ ПриоритетыЗадач.Приоритет = &Приоритет + 1)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет Убыв";
	
	Запрос.УстановитьПараметр("Ответственный", ТекСтрока.Исполнитель);
	Запрос.УстановитьПараметр("Приоритет", ТекСтрока.приоритет);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Попытка
		Выборка.следующий(); 
		Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача 		 = Выборка.Задача;
		Запись.Ответственный = Выборка.Ответственный;
		Запись.Приоритет     = Выборка.приоритет - 1;
		Запись.Записать();
	Исключение
	КонецПопытки;
	Попытка
		Выборка.следующий();
		Запись = РегистрыСведений.ПриоритетыЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача 		 = Выборка.Задача;
		Запись.Ответственный = Выборка.Ответственный;
		Запись.Приоритет     = Выборка.приоритет + 1;
		Запись.Записать();
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПонизитьПриоритет(Команда)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	ПонизитьПриоритетНаСервере(ТекСтрока);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Функция ПечатьПоПроектамНаСервере()
	
	///+ГомзМА 27.12.2022 (Задача №000000535 от 04.07.2022)
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.Задача.ПолучитьМакет("ПечатьПоПроектам");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Задача.Дата КАК Дата,
	|	Задача.Наименование КАК Наименование,
	|	Задача.Статус КАК Статус,
	|	Задача.Проект КАК Проект,
	|	Задача.Исполнитель КАК Исполнитель,
	|	Задача.Ответственный КАК Ответственный,
	|	Задача.СтатусАвтора КАК СтатусАвтора,
	|	Задача.Номер КАК Номер,
	|	Задача.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.Задача КАК Задача
	|ГДЕ
	|	Задача.Проект = &Проект
	|	И Задача.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания";
	
	Запрос.УстановитьПараметр("Проект", Проект);
	Запрос.УстановитьПараметр("ДатаНачала", ПериодДляПечати.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПериодДляПечати.ДатаОкончания);
	
	ВыборкаЗапрос = Запрос.Выполнить().Выбрать();
	
	ЗапросСтатус = Новый Запрос;
	ЗапросСтатус.Текст = 
	"ВЫБРАТЬ
	|	Задача.Статус КАК ВидСтатуса,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Задача.Ссылка) КАК Количество
	|ИЗ
	|	Документ.Задача КАК Задача
	|
	|ГДЕ
	|	Задача.Проект = &Проект
	|	И Задача.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|СГРУППИРОВАТЬ ПО
	|	Задача.Статус";
	
	ЗапросСтатус.УстановитьПараметр("Проект", Проект);
	ЗапросСтатус.УстановитьПараметр("ДатаНачала", ПериодДляПечати.ДатаНачала);
	ЗапросСтатус.УстановитьПараметр("ДатаОкончания", ПериодДляПечати.ДатаОкончания);
	
	
	ВыборкаЗапросСтатус = ЗапросСтатус.Выполнить().Выбрать();
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ГоризОбластьШапка = Макет.ПолучитьОбласть("ГоризОбластьШапка");
	ГоризОбластьШапкаТЧ = Макет.ПолучитьОбласть("ГоризОбластьШапкаТЧ");
	ОбластьШапкаТЧ = Макет.ПолучитьОбласть("ШапкаТЧ");
	ОбластьТЧ = Макет.ПолучитьОбласть("ТЧ");
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;
	
	ВыборкаЗапрос.Следующий();
	
	ТабДок.Вывести(ОбластьЗаголовок);
	
	Шапка.Параметры.Заполнить(ВыборкаЗапрос);
	Шапка.Параметры.ДатаНачала = ПериодДляПечати.ДатаНачала;
	Шапка.Параметры.ДатаОкончания = ПериодДляПечати.ДатаОкончания;
	ТабДок.Вывести(Шапка, ВыборкаЗапрос.Уровень());
	

	ТабДок.Вывести(ГоризОбластьШапка);
	
	Пока ВыборкаЗапросСтатус.Следующий() Цикл
	
		ГоризОбластьШапкаТЧ.Параметры.Заполнить(ВыборкаЗапросСтатус);
		ТабДок.Вывести(ГоризОбластьШапкаТЧ);
	
	КонецЦикла;

	ТабДок.Вывести(ОбластьШапкаТЧ);
	
	Пока ВыборкаЗапрос.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;	
		
		ОбластьТЧ.Параметры.Заполнить(ВыборкаЗапрос);
		ТабДок.Вывести(ОбластьТЧ, ВыборкаЗапрос.Уровень());
		
	КонецЦикла;
	ВставлятьРазделительСтраниц = Истина;
	Возврат ТабДок;
	///-ГомзМА 27.12.2022 (Задача №000000535 от 04.07.2022)
	
КонецФункции 


&НаКлиенте
Процедура ПечатьПоПроектам(Команда)
	
	///+ГомзМА 27.12.2022 (Задача №000000535 от 04.07.2022)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	//ПериодДляПечати = Элементы.ПериодДляПечати;
	ТабДок = ПечатьПоПроектамНаСервере();
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ПечатьПоПроектам");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "ПечатьПоПроектам";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм,Неопределено,ЭтаФорма);
	///-ГомзМА 27.12.2022 (Задача №000000535 от 04.07.2022)
	
КонецПроцедуры

&НаСервере
Функция ПечатьПоИсполнителюНаСервере(ТекСтрока)
	
	///+ГомзМА 27.12.2022 (Задача №000000535 от 04.07.2022)
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.Задача.ПолучитьМакет("ПечатьПоИсполнителю");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Задача.Дата КАК Дата,
	|	Задача.Наименование КАК Наименование,
	|	Задача.Статус КАК Статус,
	|	Задача.Исполнитель КАК Исполнитель,
	|	Задача.Ответственный КАК Ответственный,
	|	Задача.СтатусАвтора КАК СтатусАвтора,
	|	Задача.Номер КАК Номер,
	|	Задача.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.Задача КАК Задача
	|ГДЕ
	|   Задача.Исполнитель = &Исполнитель
	|	И Задача.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания";
	
	Запрос.УстановитьПараметр("Исполнитель", ТекСтрока.Исполнитель);
	Запрос.УстановитьПараметр("ДатаНачала", ПериодДляПечати.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПериодДляПечати.ДатаОкончания);
	
	ВыборкаЗапрос = Запрос.Выполнить().Выбрать();
	
	ЗапросСтатус = Новый Запрос;
	ЗапросСтатус.Текст = 
	"ВЫБРАТЬ
	|	Задача.Статус КАК ВидСтатуса,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Задача.Ссылка) КАК Количество
	|ИЗ
	|	Документ.Задача КАК Задача
	|ГДЕ
	|	Задача.Исполнитель = &Исполнитель
	|	И Задача.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|СГРУППИРОВАТЬ ПО
	|	Задача.Статус";
	
	ЗапросСтатус.УстановитьПараметр("Исполнитель", ТекСтрока.Исполнитель);
	ЗапросСтатус.УстановитьПараметр("ДатаНачала", ПериодДляПечати.ДатаНачала);
	ЗапросСтатус.УстановитьПараметр("ДатаОкончания", ПериодДляПечати.ДатаОкончания);
	
	
	ВыборкаЗапросСтатус = ЗапросСтатус.Выполнить().Выбрать();
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ГоризОбластьШапка = Макет.ПолучитьОбласть("ГоризОбластьШапка");
	ГоризОбластьШапкаТЧ = Макет.ПолучитьОбласть("ГоризОбластьШапкаТЧ");
	ОбластьШапкаТЧ = Макет.ПолучитьОбласть("ШапкаТЧ");
	ОбластьТЧ = Макет.ПолучитьОбласть("ТЧ");
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;
	
	ВыборкаЗапрос.Следующий();
	
	ТабДок.Вывести(ОбластьЗаголовок);
	
	Шапка.Параметры.Заполнить(ВыборкаЗапрос);
	Шапка.Параметры.ДатаНачала = ПериодДляПечати.ДатаНачала;
	Шапка.Параметры.ДатаОкончания = ПериодДляПечати.ДатаОкончания;
	ТабДок.Вывести(Шапка, ВыборкаЗапрос.Уровень());
	
	
	ТабДок.Вывести(ГоризОбластьШапка);
	
	Пока ВыборкаЗапросСтатус.Следующий() Цикл
	
		ГоризОбластьШапкаТЧ.Параметры.Заполнить(ВыборкаЗапросСтатус);
		ТабДок.Вывести(ГоризОбластьШапкаТЧ);
	
	КонецЦикла;

	ТабДок.Вывести(ОбластьШапкаТЧ);
	
	Пока ВыборкаЗапрос.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;	
	
		ОбластьТЧ.Параметры.Заполнить(ВыборкаЗапрос);
		ТабДок.Вывести(ОбластьТЧ, ВыборкаЗапрос.Уровень());
		
	КонецЦикла;
	ВставлятьРазделительСтраниц = Истина;
	Возврат ТабДок;
	///-ГомзМА 27.12.2022 (Задача №000000535 от 04.07.2022)
	
КонецФункции 

&НаКлиенте
Процедура ПечатьПоИсполнителю(Команда)
	
	///+ГомзМА 27.12.2022 (Задача №000000535 от 04.07.2022)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	//ПериодДляПечати = Элементы.ПериодДляПечати;
	ТабДок = ПечатьПоИсполнителюНаСервере(ТекСтрока);
	
	// создадим коллекцию печатных форм, в которую надо будет добавить нужный нам табличный документ
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ПечатьПоИсполнителю");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "ПечатьПоИсполнителю";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм,Неопределено,ЭтаФорма);
	///-ГомзМА 27.12.2022 (Задача №000000535 от 04.07.2022)
	
КонецПроцедуры


&НаСервере
Функция ПолучитьТекущегоПользователя()
	
	///+ГомзМА 30.06.2023
	ПользовательИнформационнойБазы = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	ТекущийПользователь = Справочники.Пользователи.НайтиПоНаименованию(ПользовательИнформационнойБазы.ПолноеИмя);
	
	Возврат ТекущийПользователь;
	///-ГомзМА 30.06.2023

КонецФункции // ПолучитьТекущегоПользователя()

&НаСервере
Функция ПользовательСодержитРоли()

	///+ГомзМА 30.06.2023
	Результат = Ложь;
	
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("ПолныеПрава"))  	 ИЛИ
		 ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("дт_ПолныеПрава")) ИЛИ
		 ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя = Справочники.Пользователи.НайтиПоНаименованию("Ковальков Федор Александрович").ПолноеНаименование() Тогда
	
			Результат = Истина;
	
	КонецЕсли;
	
	Возврат Результат;
	///-ГомзМА 30.06.2023

КонецФункции // ПользовательСодержитРоли()


#КонецОбласти




&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	//Нас интересует только событие нажатия на чекбокс
	Если Поле = Элементы.Контроль Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Если ТекущиеДанные.Контроль Тогда
				СнятьКонтроль(ТекущиеДанные.Ссылка);
			Иначе
				ПоставитьКонтроль(ТекущиеДанные.Ссылка);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	//Параметр в динамическом списке нужно обновить
	//Список.Параметры.УстановитьЗначениеПараметра("ВыбраннаяЗапись", ВыбраннаяЗапись);
	
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура СнятьКонтроль(Запись)
	Док = Запись.получитьОбъект();
	Док.контроль = Ложь;
	Док.Записать();
КонецПроцедуры

&НаСервере
Процедура ПоставитьКонтроль(Запись)
	Док = Запись.получитьОбъект();
	Док.контроль = Истина;
	Док.Записать();
КонецПроцедуры


&НаКлиенте
Процедура АктивныеПриИзменении(Элемент)
	ОбновитьСписок();	
КонецПроцедуры


&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры


&НаКлиенте
Процедура ИсполнительДашбордПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры


&НаКлиенте
Процедура ПроектДашбордПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры


&НаКлиенте
Процедура ИгнорироватьПериодПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры


&НаКлиенте
Процедура АвторИлиИсполнительПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры




