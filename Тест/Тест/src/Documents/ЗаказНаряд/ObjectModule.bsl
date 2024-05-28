#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	#Область ПрограммныйИнтерфейс
	
	
	Процедура ОбработкаЗаполнения1(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
		
		
				
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	ЗаказКлиента.Ссылка КАК Ссылка,
			|	ЗаказКлиента.Клиент КАК Клиент,ОбработкаЗаполнения
			|	ЗаказКлиента.Ответственный КАК Ответственный,
			|	ЗаказКлиента.Проект КАК Проект
			|ИЗ
			|	Документ.ЗаказКлиента КАК ЗаказКлиента
			|ГДЕ
			|	ЗаказКлиента.Ссылка = &Ссылка";
			
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
			
			РезультатЗапроса = Запрос.ВыполнитьПакет();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса[0].Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Клиент 		 = ВыборкаДетальныеЗаписи.Клиент;
				Инициатор 	 = ПолучитьСотрудника(ВыборкаДетальныеЗаписи.Ответственный);
				ЗаказКлиента = ВыборкаДетальныеЗаписи.ссылка;
				Проект 		 = ВыборкаДетальныеЗаписи.Проект;
			КонецЦикла;
			
			///+ГомзМА 15.08.2023
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Рас_Комплектовка") Тогда
			Организация 			= ДанныеЗаполнения.Организация;
			Клиент 					= ДанныеЗаполнения.Клиент;
			ВосстановлениеДеталей 	= ДанныеЗаполнения.Ссылка;
			Склад 					= Справочники.Склады.НайтиПоНаименованию("000000002");
			
			Если ДанныеЗаполнения.РаботыСписок.Количество() > 0 Тогда
				Для каждого СтрокаТЧ Из ДанныеЗаполнения.РаботыСписок Цикл
					НоваяСтрока = Работы.Добавить();
					НоваяСтрока.Работа 		= СтрокаТЧ.Работа;
					Если СтрокаТЧ.Содержание = "" Тогда
						НоваяСтрока.Содержание  = "Работу выполнил: " + Строка(СтрокаТЧ.Ответственный);
					Иначе
						НоваяСтрока.Содержание  = "Работу выполнил: " + Строка(СтрокаТЧ.Ответственный) + " / " + СтрокаТЧ.Содержание;
					КонецЕсли;
					НоваяСтрока.Цена 		= СтрокаТЧ.Цена;
					НоваяСтрока.Количество 	= СтрокаТЧ.Количество;
					НоваяСтрока.СуммаВсего 	= СтрокаТЧ.СуммаВсего;
					НоваяСтрока.Сумма 		= СтрокаТЧ.Сумма;
					НоваяСтрока.Нормочас 	= СтрокаТЧ.Нормочас;
				КонецЦикла;
			КонецЕсли;
			
			//Если ДанныеЗаполнения.НоменклатураСписок.Количество() > 0 Тогда
			//	Для каждого СтрокаТЧ Из ДанныеЗаполнения.НоменклатураСписок Цикл
			//		НоваяСтрока = Товары.Добавить();
			//		НоваяСтрока.Номенклатура = СтрокаТЧ.Номенклатураспис;
			//		НоваяСтрока.Количество 	 = СтрокаТЧ.Количество;
			//		//НоваяСтрока.Цена 		 = СтрокаТЧ.
			//		НоваяСтрока.Автомобиль 	 = СтрокаТЧ.Автомобиль;
			//		//НоваяСтрока.Сумма 		 = 
			//		НоваяСтрока.Партия 		 = СтрокаТЧ.Партия;			
			//	КонецЦикла;
			//КонецЕсли;
			///-ГомзМА 15.08.2023
		Иначе 
			Инициатор = Справочники.Сотрудники.НайтиПоРеквизиту("Пользователь",Пользователи.ТекущийПользователь());
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Состояние) Тогда
			Состояние = Перечисления.СостоянияЗаказНаряда.Предварительный;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СостояниеРасчетовКлиентаКомитента) Тогда
			СостояниеРасчетовКлиентаКомитента = Перечисления.СостоянияВзаиморасчетов.Долг;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СостояниеРасчетов) Тогда
			СостояниеРасчетов = Перечисления.СостоянияВзаиморасчетов.Долг;
		КонецЕсли;
		
		ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
		
		ВидОперации = Документы.ЗаказНаряд.ПолучитьВидОперацииПоДокументуОснованию(Неопределено);
		
		Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказНаряд.ЗаказНарядВнутренний") Тогда
			БезДоговора = Истина;
		КонецЕсли;
		
		//Волков ИО 05.03.24 ++   
		Попытка
		Если Не ЗначениеЗаполнено(Клиент) Тогда
			Клиент = ДанныеЗаполнения.Проект.Клиент;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВинКод) Тогда
			ВинКод =  ДанныеЗаполнения.Проект.ВинКод;
		КонецЕсли; 
		
		Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
			ДатаНачала = ТекущаяДата();	
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Проект) Тогда
			Проект = ДанныеЗаполнения.Проект;		
		КонецЕсли; 
	Исключение
	КонецПопытки;
	// ++МазинЕС 24-05-24
			Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Расходы") Тогда
				
	
			Конецесли; 
	// --МазинЕС 24-05-24
		//Волков ИО 05.03.24 --
		
	КонецПроцедуры
	
	Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
		
		Если ОбменДанными.Загрузка Тогда
			Возврат;
		КонецЕсли;
		
		
		ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
		
		СуммаТовары = Товары.Итог("СуммаВсего");
		СуммаРаботы = Работы.Итог("СуммаВсего");
		СуммаАгентские = ТоварыНаКомиссии.Итог("СуммаАгентские");
		СуммаТоварыНаКомиссии = ТоварыНаКомиссии.Итог("СуммаВсего");
		
		СуммаДокумента = СуммаРаботы + СуммаТовары + СуммаТоварыНаКомиссии;
		
		КоличествоВремяПлан = Работы.Итог("ВремяПлан");
		КоличествоВремяФакт = Работы.Итог("ВремяФакт");
		
		Если БезДоговора Тогда
			ДоговорКонтрагента = Неопределено
		КонецЕсли;
		
		// Строки с пустыми исполнителями очистить
		Индекс = 0;
		Пока Индекс < Исполнители.Количество() Цикл
			СтрокаТаблицы = Исполнители[Индекс];
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Исполнитель) Тогда
				Исполнители.Удалить(Индекс);
			Иначе
				Индекс = Индекс + 1;
			КонецЕсли;
		КонецЦикла;
		
		// Руководитель
		Если Не ЗначениеЗаполнено(Руководитель) 
			И ЗначениеЗаполнено(Организация) Тогда
			Руководитель = дт_ЗаполнениеОбъектов.ПолучитьПоследнееЗначение(
			Метаданные().Имя, 
			"Руководитель", 
			Новый Структура("Организация", Организация)
			);
			
			Если Не ЗначениеЗаполнено(Руководитель) Тогда
				Руководитель = дт_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьОсновноеОтветственноеЛицоОрганизации(Организация);
			КонецЕсли;	
		КонецЕсли;
		
		// Заполнить дату выполнения
		СтрокиИсполнители =  Исполнители.НайтиСтроки(Новый Структура("Дата", '00010101'));
		
		ДатаРабот = ?(Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаказНаряда.Выполнен")
		И ЗначениеЗаполнено(ДатаОкончания), 
		ДатаОкончания, 
		Макс(Дата, ДатаНачала)
		);
		
		Для каждого СтрокаИсполнитель Из СтрокиИсполнители Цикл
			СтрокаИсполнитель.Дата = ДатаРабот;
		КонецЦикла;
		
		// Ответственные
		ОбновитьОтветственных();	
		
		///+ГомзМА 15.08.2023
		Если Товары.Количество() <> 0 Тогда
			Для каждого СтрокаТЧ Из Товары Цикл
				СсылкаНаДокумент = ПолучитьСсылкуНаДокументРасКомплектовка(СтрокаТЧ.Партия);
				Если СсылкаНаДокумент <> Неопределено Тогда
					ДокОбъект = СсылкаНаДокумент.ПолучитьОбъект();
					ДокОбъект.ДетальПродана = Истина;
					ДокОбъект.Записать();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		///-ГомзМА 15.08.2023
		
		/// +Комлев 07.05.2024
	//ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	
	//Запрос = Новый Запрос;
	//Запрос.Текст =
		//"ВЫБРАТЬ
		//|	ДолжностиСотрудниковСрезПоследних.Сотрудник.Наименование КАК Сотрудник
		//|ИЗ
		//|	РегистрСведений.ДолжностиСотрудников.СрезПоследних(, Должность.Наименование ПОДОБНО ""%"" + ""Менеджер по продажам"" +
		//|		""%"") КАК ДолжностиСотрудниковСрезПоследних";
	
	
	//РезультатЗапроса = Запрос.Выполнить();
	
	//Выборка = РезультатЗапроса.Выбрать();
	
	//Пока Выборка.Следующий() Цикл
		//Если ЭтоНовый() И ТекущийПользователь.ПолноеИмя = Выборка.Сотрудник Тогда
			//Дубнов = Справочники.Сотрудники.НайтиПоНаименованию("Дубнов Евгений Владимирович");
			//Если НЕ ЗначениеЗаполнено(МенеджерПоПродажам) Тогда
				//МенеджерПоПродажам = Инициатор;
			//КонецЕсли;
			
			//Инициатор = Дубнов;
			
		//КонецЕсли;
	//КонецЦикла;
	
	
	/// -Комлев 07.05.2024
	КонецПроцедуры
	
	
	Функция ПолучитьСсылкуНаДокументРасКомплектовка(Инкод)
		
		///+ГомзМА 15.08.2023
		Результат = Неопределено;
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Рас_Комплектовка.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.Рас_Комплектовка КАК Рас_Комплектовка
		|ГДЕ
		|	Рас_Комплектовка.Инкод = &Инкод
		|	И НЕ Рас_Комплектовка.ДетальПродана";
		
		Запрос.УстановитьПараметр("Инкод", Инкод);
		
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
		Если РезультатЗапроса.Количество() > 0 Тогда
			РезультатЗапроса.Следующий();
			
			Результат = РезультатЗапроса.Ссылка;
		КонецЕсли;
		
		Возврат Результат;
		///-ГомзМА 15.08.2023
		
	КонецФункции // ПолучитьСсылкуНаДокументРасКомплектовка()
	
	
	Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
		ДополнительныеСвойства.Вставить("ЭтоНовый",                    ЭтоНовый()); 
		ДополнительныеСвойства.Вставить("ДатаДокументаСдвинутаВперед", Ложь); 
		ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
		
		
		ПараметрыПроведения = Документы.ЗаказНаряд.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		дт_ОбщегоНазначения.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		дт_Склад.ПодготовитьНаборыЗаписей(ЭтотОбъект);
		дт_Автосервис.ПодготовитьНаборыЗаписей(ЭтотОбъект);
		дт_Продажи.ПодготовитьНаборыЗаписей(ЭтотОбъект);
		дт_СебестоимостьТоваров.ПодготовитьНаборыЗаписей(ЭтотОбъект);
		дт_РасчетыСПоставщиками.ПодготовитьНаборыЗаписей(ЭтотОбъект);	
		
		// Формирование движений
		дт_Склад.ОтразитьДвижения(ПараметрыПроведения, Движения, Отказ);
		дт_Автосервис.ОтразитьДвижения(ПараметрыПроведения, Движения, Отказ);
		дт_Продажи.ОтразитьДвижения(ПараметрыПроведения, Движения, Отказ);
		дт_СебестоимостьТоваров.ОтразитьДвижения(ПараметрыПроведения, Движения, Отказ);
		дт_РасчетыСПоставщиками.ОтразитьРасчетыСПоставщиками(ПараметрыПроведения, Движения, Отказ);
		
		
		//////////////////////////////////Запись движений происходит из документов Списаний////////////////////////////////////////////////	
		/////+ГомзМА 02.05.2023 
		//// Формирование движения ТМЦ
		//
		//Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаказНаряда.Выполнен") И ЗначениеЗаполнено(ТМЦ) Тогда
		//	Движения.ДвижениеТМЦСкладСнабжение.Записывать = Истина;
		//	
		//// регистр ДвижениеТМЦСкладСнабжение Расход
		//Для Каждого ТекСтрокаТМЦ Из ТМЦ Цикл
		//	Движение 					= Движения.ДвижениеТМЦСкладСнабжение.Добавить();
		//	Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
		//	Движение.Период 	 		= Дата;
		//	Движение.ТМЦ 		 		= ТекСтрокаТМЦ.ТМЦ;
		//	Движение.МестоХранения 		= ТекСтрокаТМЦ.СкладСписания;
		//	Движение.ИнвентарныйНомер 	= ТекСтрокаТМЦ.ИнвентарныйНомер;
		//	Движение.Количество 		= ТекСтрокаТМЦ.Количество;
		//	Движение.Цена 				= ТекСтрокаТМЦ.Цена;
		//КонецЦикла;
		//
		//Движения.Записать();
		//
		/////+ГомзМА 02.05.2023
		//Отказ = РегистрыНакопления.ДвижениеТМЦСкладСнабжение.ЕстьОтрицательныеОстатки(Ссылка, Дата, ТекСтрокаТМЦ.СкладСписания);
		/////-ГомзМА 02.05.2023
		//
		//КонецЕсли;
		/////-ГомзМА 02.05.2023
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаказНаряда.Выполнен") Тогда
			
			ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаТовары", 			ПараметрыПроведения.ТаблицаТовары);
			ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаТоварыНаКомиссии", 	ПараметрыПроведения.ТаблицаТоварыНаКомиссии);
			ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаМатериалы", 			ПараметрыПроведения.ТаблицаМатериалы);
			ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаТоварыОрганизаций", 	ПараметрыПроведения.ТаблицаТоварыОрганизаций);
			
			ДополнительныеСвойства.ДляПроведения.МоментКонтроля = Новый Граница(ДатаОкончания, ВидГраницы.Включая);
			
			// Контроль отрицательных остаткок по регистрам накопления (только в рамках Д_Доработок)
			Документы.ЗаказНаряд.ВыполнитьКонтроль(ЭтотОбъект, "Материалы", ДополнительныеСвойства, Отказ);
			Документы.ЗаказНаряд.ВыполнитьКонтроль(ЭтотОбъект, "Товары", ДополнительныеСвойства, Отказ);
			Документы.ЗаказНаряд.ВыполнитьКонтроль(ЭтотОбъект, "ТоварыНаКомиссии", ДополнительныеСвойства, Отказ);
			
			Документы.ЗаказНаряд.ВыполнитьКонтрольТоварыОрганизаций(ЭтотОбъект, "Товары", ДополнительныеСвойства, Отказ);
			МассивТоваров = новый массив;
			Для каждого стр из Товары Цикл
				
				МассивТоваров.Добавить(стр.Номенклатура);
			КонецЦикла;
			//дт_ОбменССайтами.СформироватьСписокДеталейПоштучно(МассивТоваров);
			
		//КонецЕсли;
		
		//Волков ИО 07.12.23 ++
		// РН БалансКлиента Расход
		Если СписатьСБалансаКлиента Тогда 
			Движения.БалансКлиента.Записывать = Истина;
			Движение = Движения.БалансКлиента.Добавить();
			движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Клиент = Клиент;
			Движение.Баланс = СуммаДокумента;
		КонецЕсли;
		//Волков ИО 07.12.23 --
		
	КонецПроцедуры
	
	Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
		
		Если ОбменДанными.Загрузка Тогда
			Возврат
		КонецЕсли;
		
		НепроверяемыеРеквизиты = Новый Массив();
		НепроверяемыеРеквизиты.Добавить("АвтомобильСобственный");
		НепроверяемыеРеквизиты.Добавить("Исполнители.Дата");	
		НепроверяемыеРеквизиты.Добавить("Исполнители.ВремяФакт");	
		НепроверяемыеРеквизиты.Добавить("Работы.ВремяФакт");	
		
		// Обязательные по видам операций
		Если ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказНаряд.ЗаказНарядВнутренний") Тогда
			НепроверяемыеРеквизиты.Добавить("Инициатор");	
		ИначеЕсли ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказНаряд.ЗаказНаряд") Тогда
			//НепроверяемыеРеквизиты.Добавить("Клиент");	
			//НепроверяемыеРеквизиты.Добавить("Организация");	
			НепроверяемыеРеквизиты.Добавить("Автомобиль");
			НепроверяемыеРеквизиты.Добавить("ДоговорКонтрагента");	
			//		НепроверяемыеРеквизиты.Добавить("Товары.Склад");	
			//		НепроверяемыеРеквизиты.Добавить("Материалы.Склад");	
		КонецЕсли;
		
		
		// Обязательные связанные
		Если ЗначениеЗаполнено(Склад) Тогда
			НепроверяемыеРеквизиты.Добавить("Товары.Склад");	
			НепроверяемыеРеквизиты.Добавить("Материалы.Склад");	
		КонецЕсли;
		
		///+ГомзМА 04.10.2023
		Если ВнутреннийЗаказНаряд Тогда
			НепроверяемыеРеквизиты.Добавить("Клиент");
			НепроверяемыеРеквизиты.Добавить("ДатаНачала");
			НепроверяемыеРеквизиты.Добавить("ДатаОкончания");
		КонецЕсли;
		///-ГомзМА 04.10.2023
		
		Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаказНаряда.Выполнен") Тогда
			ПроверяемыеРеквизиты.Добавить("ДатаНачала");	
			ПроверяемыеРеквизиты.Добавить("ДатаОкончания");	
			ПроверяемыеРеквизиты.Добавить("Работы.Работа");	
			ПроверяемыеРеквизиты.Добавить("Работы.Количество");	
		ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаказНаряда.ВРаботе") Тогда
			ПроверяемыеРеквизиты.Добавить("ДатаНачала");	
		КонецЕсли;	
		
		
		Если БезДоговора Тогда
			НепроверяемыеРеквизиты.Добавить("ДоговорКонтрагента");	
		КонецЕсли;
		
		Если НЕ ПолучитьФункциональнуюОпцию("дт_ОтгрузкаСРазныхСкладов") Тогда
			НепроверяемыеРеквизиты.Добавить("Товары.Склад");
			НепроверяемыеРеквизиты.Добавить("Материалы.Склад");
		КонецЕсли;
		
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
		
		Если НЕ дт_Нумерация.НомерУникален(ЭтотОбъект, Истина, Истина, Истина, "НомерУПД", Отказ) Тогда
			// можно не сообщать об ошибке
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаНачала) 
			И ЗначениеЗаполнено(ДатаОкончания) 
			И ДатаНачала > ДатаОкончания Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Дата окончания не может быть меньше даты начала",
			,
			"ДатаОкончания",
			"Объект",
			Отказ
			);
			
		КонецЕсли;
		
		ПроверятьДатуИсполнителей = НепроверяемыеРеквизиты.Найти("Исполнители.Дата") = Неопределено;
		ПроверятьВремяФактИсполнителей =  НепроверяемыеРеквизиты.Найти("Исполнители.ВремяФакт") = Неопределено;
		
		Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказНаряд.ЗаказНарядВнутренний") 
			И (ПроверятьДатуИсполнителей
			ИЛИ ПроверятьВремяФактИсполнителей) Тогда
			
			_ДатаОкончанияЗаполнена = ЗначениеЗаполнено(ДатаОкончания);
			
			Для каждого СтрокаТаблицы Из Исполнители Цикл
				
				СтрокаРаботы = Неопределено;
				
				Если ПроверятьВремяФактИсполнителей 
					И СтрокаТаблицы.ВремяФакт = 0 Тогда
					
					СтрокаРаботы = Работы.Найти(СтрокаТаблицы.ИдентификаторСтрокиРодитель, "ИдентификаторСтроки");
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон("Для строки %1 списка Работы не заполнено Время факт. %2 по исполнителю %3", 
					?(СтрокаРаботы = Неопределено, 0, СтрокаРаботы.НомерСтроки), 
					Формат(СтрокаТаблицы.Дата, "ДЛФ=D;"),
					СтрокаТаблицы.Исполнитель
					),
					,
					,
					"Объект",
					Отказ
					);
					
				КонецЕсли;
				
				Если ПроверятьДатуИсполнителей
					И ЗначениеЗаполнено(СтрокаТаблицы.Дата)
					И ((СтрокаТаблицы.Дата > ДатаОкончания
					И _ДатаОкончанияЗаполнена)
					ИЛИ (СтрокаТаблицы.Дата < ДатаНачала)) Тогда
					
					Если СтрокаРаботы = Неопределено Тогда
						СтрокаРаботы = Работы.Найти(СтрокаТаблицы.ИдентификаторСтрокиРодитель, "ИдентификаторСтроки");
					КонецЕсли;
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон("Для строки %1 списка Работы дата %2 по исполнителю %3 не входит в период работ по заказ-наряду", 
					?(СтрокаРаботы = Неопределено, 0, СтрокаРаботы.НомерСтроки), 
					Формат(СтрокаТаблицы.Дата, "ДЛФ=D;"),
					СтрокаТаблицы.Исполнитель
					),
					,
					,
					"Объект",
					Отказ
					);
					
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		// время факт не должно превышать время план
		Для каждого СтрокаТаблицы Из Работы Цикл
			Если СтрокаТаблицы.ВремяФакт > СтрокаТаблицы.ВремяПлан Тогда
				Поле = "Объект." + ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Работы", СтрокаТаблицы.НомерСтроки, "ВремяФактСек");	
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон("В строке %1 списка Работы время факт. превышает время план.",
				СтрокаТаблицы.НомерСтроки),
				,
				Поле,
				,
				Отказ
				);
				
				
				
			КонецЕсли;
		КонецЦикла;	
		
	КонецПроцедуры
	
	Процедура ПриКопировании(ОбъектКопирования)
		
		Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
		Ответственный = Пользователи.ТекущийПользователь();
		
		НомерУПД = "";
		ДатаУПД = Дата(1, 1, 1);
		
	КонецПроцедуры
	
	Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
		
		Если ВнутреннийЗаказНаряд Тогда
			Префикс = "ВН-";
		Иначе
			Префикс = "00"; //дт_ОбщегоНазначения.ПрефиксОрганизации(Организация);
		КонецЕсли;
		
	КонецПроцедуры
	
	
	
	#КонецОбласти
	
	#Область СлужебныйПрограммныйИнтерфейс
	
	Функция ОбновитьОтветственных() Экспорт
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаказНарядИсполнители.ВремяФакт,
		|	ЗаказНарядИсполнители.Исполнитель
		|ПОМЕСТИТЬ втИсполнители
		|ИЗ
		|	&Исполнители КАК ЗаказНарядИсполнители
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаказНарядОтветственные.НомерСтроки,
		|	ЗаказНарядОтветственные.Сотрудник,
		|	ЗаказНарядОтветственные.Роль,
		|	ЗаказНарядОтветственные.Ставка,
		|	ЗаказНарядОтветственные.СуммаНачислено
		|ПОМЕСТИТЬ втОтветственные
		|ИЗ
		|	&Ответственные КАК ЗаказНарядОтветственные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втОтветственные.Сотрудник,
		|	0 КАК Выработка
		|ПОМЕСТИТЬ втВыработкаВсе
		|ИЗ
		|	втОтветственные КАК втОтветственные
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	втИсполнители.Исполнитель,
		|	СУММА(втИсполнители.ВремяФакт) КАК ВремяФакт
		|ИЗ
		|	втИсполнители КАК втИсполнители
		|СГРУППИРОВАТЬ ПО
		|	втИсполнители.Исполнитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втВыработкаВсе.Сотрудник,
		|	СУММА(втВыработкаВсе.Выработка) КАК Выработка
		|ПОМЕСТИТЬ втВыработка
		|ИЗ
		|	втВыработкаВсе КАК втВыработкаВсе
		|СГРУППИРОВАТЬ ПО
		|	втВыработкаВсе.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втОтветственные.Сотрудник КАК Сотрудник,
		|	втОтветственные.Роль,
		|	втОтветственные.Ставка,
		|	втВыработка.Выработка,
		|	втВыработка.Выработка * втОтветственные.Ставка КАК CуммаНачислено,
		|	втОтветственные.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	втОтветственные КАК втОтветственные
		|		ЛЕВОЕ СОЕДИНЕНИЕ втВыработка КАК втВыработка
		|		ПО втОтветственные.Сотрудник = втВыработка.Сотрудник
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	втВыработка.Сотрудник,
		|	NULL,
		|	0,
		|	втВыработка.Выработка,
		|	NULL,
		|	999
		|ИЗ
		|	втВыработка КАК втВыработка
		|		ЛЕВОЕ СОЕДИНЕНИЕ втОтветственные КАК втОтветственные
		|		ПО втВыработка.Сотрудник = втОтветственные.Сотрудник
		|ГДЕ
		|	втОтветственные.Сотрудник ЕСТЬ NULL
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки,
		|	Сотрудник";
		
		
		Запрос.УстановитьПараметр("Исполнители", Исполнители.Выгрузить());
		Запрос.УстановитьПараметр("Ответственные", Ответственные.Выгрузить());
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Ответственные.Загрузить(РезультатЗапроса.Выгрузить());
		
		ДатаАктуальности = ДатаОкончания;
		
		Если Не ЗначениеЗаполнено(ДатаАктуальности) Тогда
			ДатаАктуальности = ДатаНачала;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДатаАктуальности) Тогда
			ДатаАктуальности = Дата;
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		
		Для каждого СтрокаТаблицы Из Ответственные Цикл
			Если СтрокаТаблицы.Ставка = 0 
				ИЛИ ЗначениеЗаполнено(СтрокаТаблицы.Сотрудник) Тогда
				
				Сотрудник = дт_Сотрудники.СотрудникПоПользователю(СтрокаТаблицы.Сотрудник); 
				Если ЗначениеЗаполнено(Сотрудник) Тогда
					СтрокаТаблицы.Ставка = дт_Зарплата.ПолучитьСтавкуСотрудника(Сотрудник, ДатаАктуальности);
				КонецЕсли;
				
			КонецЕсли;
			
			СтрокаТаблицы.СуммаНачислено = СтрокаТаблицы.Ставка * СтрокаТаблицы.Выработка; 
			
		КонецЦикла;
		
	КонецФункции
	
	Функция ПолучитьСотрудника(Юзер) Экспорт
		
		Запрос = Новый запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Пользователь = &Пользователь";
		Запрос.УстановитьПараметр("Пользователь",Юзер);
		выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		Возврат выборка.ссылка;
		
	КонецФункции
	
	
	
	#КонецОбласти
	
	#Область СлужебныеПроцедурыИФункции
	
	
	
	#КонецОбласти
	
#КонецЕсли
