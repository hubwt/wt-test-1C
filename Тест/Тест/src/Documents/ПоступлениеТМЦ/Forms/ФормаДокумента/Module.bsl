

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	///+ГомзМА 12.04.2023
	ИнвентарныеНомера.Параметры.УстановитьЗначениеПараметра("ДокументПоступления", Объект.Ссылка);
	///-ГомзМА 12.04.2023

КонецПроцедуры


&НаКлиенте
Процедура СписокТМЦКоличествоПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("СписокТМЦ", "Количество");
КонецПроцедуры

&НаКлиенте
Процедура СписокТМЦЦенаПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаИзмененияСтроки(ИмяТабличнойЧасти, Поле = Неопределено, ДанныеСтроки = Неопределено)
	
	ТекДанные = ?(ДанныеСтроки = Неопределено, Элементы[ИмяТабличнойЧасти].ТекущиеДанные, ДанныеСтроки);
	
	Если Поле = "Сумма" Тогда
		Если ТекДанные.Количество <> 0 Тогда
			ТекДанные.Цена = ТекДанные.Сумма / ТекДанные.Количество;
		КонецЕсли;	
	Иначе	
		ТекДанные.Сумма = ТекДанные.Цена * ТекДанные.Количество;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаИзмененияСтроки()

&НаСервере
Функция ПолучитьТМЦПоНакладнойНаСервере(ТекДанные)

	/////+ГомзМА 10.04.2023
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	Инвентарь.ТМЦПоНакладной КАК ТМЦПоНакладной
	//	|ИЗ
	//	|	Справочник.Инвентарь КАК Инвентарь
	//	|ГДЕ
	//	|	Инвентарь.Ссылка = &Ссылка";
	//
	//Запрос.УстановитьПараметр("Ссылка", ТекДанные);
	//
	//ТМЦПоНакладной = Запрос.Выполнить().Выбрать();
	//
	//ТМЦПоНакладной.Следующий();
	//
	//Возврат ТМЦПоНакладной.ТМЦПоНакладной;
	/////-ГомзМА 10.04.2023

	///+ГомзМА 10.04.2023
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СкладСнабжение.ТМЦПоНакладной КАК ТМЦПоНакладной
		|ИЗ
		|	Справочник.СкладСнабжение КАК СкладСнабжение
		|ГДЕ
		|	СкладСнабжение.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ТекДанные);
	
	ТМЦПоНакладной = Запрос.Выполнить().Выбрать();
	
	ТМЦПоНакладной.Следующий();
	
	Возврат ТМЦПоНакладной.ТМЦПоНакладной;
	///-ГомзМА 10.04.2023
	
КонецФункции 


&НаКлиенте
Процедура СписокТМЦТМЦПриИзменении(Элемент)
	
	ТекДанные = Элементы.СписокТМЦ.ТекущиеДанные;
	ТМЦПоНакладной = ПолучитьТМЦПоНакладнойНаСервере(ТекДанные.ТМЦ);
	
	Если НЕ ЗначениеЗаполнено(ТекДанные.Количество) Тогда
		ТекДанные.Количество = 1;
	КонецЕсли;
	ТекДанные.Склад 		 = Объект.склад;
	ТекДанные.цена       	 = ПолучениеЦены(ТекДанные.ТМЦ);
	ТекДанные.Код        	 = ПолучениеКода(ТекДанные.ТМЦ);
	ТекДанные.ТМЦПоНакладной = ТМЦПоНакладной;
	ОбработкаИзмененияСтроки("СписокТМЦ", "Цена");
	
КонецПроцедуры

&НаСервере
Функция  ПолучениеЦены(ТМЦ)
	//Запрос = новый запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	Инвентарь.Стоимость КАК Стоимость
	//               |ИЗ
	//               |	Справочник.Инвентарь КАК Инвентарь
	//               |ГДЕ
	//               |	Инвентарь.Ссылка = &Ссылка";
	//запрос.УстановитьПараметр("Ссылка", ТМЦ);
	//Выборка = запрос.Выполнить().Выбрать();
	//Выборка.Следующий();
	//Возврат Выборка.стоимость;
	
	///
	Запрос = новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СкладСнабжение.Стоимость КАК Стоимость
	               |ИЗ
	               |	Справочник.СкладСнабжение КАК СкладСнабжение
	               |ГДЕ
	               |	СкладСнабжение.Ссылка = &Ссылка";
	запрос.УстановитьПараметр("Ссылка", ТМЦ);
	Выборка = запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.стоимость;
	///
	
КонецФункции


&НаСервере
Функция  ПолучениеКода(ТМЦ)
	
	
	//	Запрос = новый запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	Инвентарь.Код КАК код
	//               |ИЗ
	//               |	Справочник.Инвентарь КАК Инвентарь
	//               |ГДЕ
	//               |	Инвентарь.Ссылка = &Ссылка";
	//запрос.УстановитьПараметр("Ссылка", ТМЦ);
	//Выборка = запрос.Выполнить().Выбрать();
	//Выборка.Следующий();
	//Возврат Выборка.код;
	
	///
	Запрос = новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СкладСнабжение.Код КАК код
	               |ИЗ
	               |	Справочник.СкладСнабжение КАК СкладСнабжение
	               |ГДЕ
	               |	СкладСнабжение.Ссылка = &Ссылка";
	запрос.УстановитьПараметр("Ссылка", ТМЦ);
	Выборка = запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.код;
	///
	
КонецФункции


&НаСервере
Функция ПроверитьМодифицированностьДокументаНаСервере() Экспорт
	
	/////+ГомзМА 11.04.2023
	//Если ЭтаФорма.Модифицированность Тогда
	//	ДокументМодифицирован = Истина;
	//Иначе
	//	ДокументМодифицирован = Ложь;
	//КонецЕсли;
	//
	//Возврат ДокументМодифицирован;
	/////-ГомзМА 11.04.2023

КонецФункции // ПроверитьМодифицированностьДокументаНаСервере() 



//&НаСервере
//Процедура ЗаполнитьИнвентарныеНомераНаСервере(Отказ = Ложь)
//	
//	///+ГомзМА 12.04.2023
//	ДанныеЗаполнения = Новый Структура();
//	ДанныеЗаполнения.Вставить("ДокументПоступления", Объект.Ссылка);
//	ДанныеЗаполнения.Вставить("ДатаПоступления", Объект.Дата);
//	ДанныеЗаполнения.Вставить("ДатаПоступления2", 
//	
//	КоличествоИнвНомеровПоТМЦ = ПолучитьКоличествоИнвентарныхНомеровПоТМЦ();
//	
//	Для каждого СтрокаТаблицы Из Объект.СписокТМЦ Цикл
//		
//		Если КоличествоИнвНомеровПоТМЦ.Количество() = 0 Тогда
//			Для Сч = 1 По СтрокаТаблицы.Количество Цикл
//				ДанныеЗаполнения.Вставить("ТМЦ", СтрокаТаблицы.ТМЦ);
//				НовыйКод = Справочники.ИнвентарныеНомера.СоздатьНовыйЭлемент(ДанныеЗаполнения, Отказ);
//			КонецЦикла;
//			
//		КонецЕсли;
//		
//		Для каждого СтрокаИнвНомеров Из КоличествоИнвНомеровПоТМЦ Цикл
//			Если СтрокаТаблицы.ТМЦ = СтрокаИнвНомеров.Владелец И 
//				Объект.Ссылка = СтрокаИнвНомеров.ДокументПоступления И 
//				СтрокаТаблицы.Количество > СтрокаИнвНомеров.Количество Тогда
//				
//				Для Сч = 1 По СтрокаТаблицы.Количество - СтрокаИнвНомеров.Количество Цикл
//					ДанныеЗаполнения.Вставить("ТМЦ", СтрокаТаблицы.ТМЦ);
//					НовыйКод = Справочники.ИнвентарныеНомера.СоздатьНовыйЭлемент(ДанныеЗаполнения, Отказ); 
//				КонецЦикла;
//				
//				
//			КонецЕсли;
//		КонецЦикла;
//		


//		//
//		//Если Не ЗначениеЗаполнено(СтрокаТаблицы.Наименование) Тогда
//		//	
//		//	
//		//	
//		//КонецЕсли;
//		
//	КонецЦикла;
//	///-ГомзМА 12.04.2023
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ЗаполнитьИнвентарныеНомера(Команда)
//	
//	///+ГомзМА 12.04.2023
//	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
//		Если НЕ Записать() Тогда
//			Возврат
//		КонецЕсли;
//	КонецЕслИ;
//	
//	ЗаполнитьИнвентарныеНомераНаСервере();
//	///-ГомзМА 12.04.2023
//	
//КонецПроцедуры

//&НаСервере
//Функция ПолучитьКоличествоИнвентарныхНомеровПоТМЦ()

//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	ИнвентарныеНомера.Владелец КАК Владелец,
//		|	ИнвентарныеНомера.ДатаПоступления КАК ДатаПоступления,
//		|	ИнвентарныеНомера.ДокументПоступления КАК ДокументПоступления,
//		|	СУММА(1) КАК Количество
//		|ИЗ
//		|	Справочник.ИнвентарныеНомера КАК ИнвентарныеНомера
//		|ГДЕ
//		|	ИнвентарныеНомера.ДокументПоступления = &ДокументПоступления
//		|
//		|СГРУППИРОВАТЬ ПО
//		|	ИнвентарныеНомера.Владелец,
//		|	ИнвентарныеНомера.ДатаПоступления,
//		|	ИнвентарныеНомера.ДокументПоступления";
//	
//	Запрос.УстановитьПараметр("ДатаПоступления", Объект.Дата);
//	Запрос.УстановитьПараметр("ДокументПоступления", Объект.Ссылка);
//	
//	РезультатЗапроса = Запрос.Выполнить().Выгрузить();

//	Возврат РезультатЗапроса;
//	
//КонецФункции 

