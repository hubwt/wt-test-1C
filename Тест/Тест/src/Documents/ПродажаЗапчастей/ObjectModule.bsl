#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	#Область ПрограммныйИнтерфейс
	
	Функция ВездеЕстьКод()
		рез = истина;
		Для Каждого с Из Таблица Цикл
			Если ПустаяСтрока(с.укод) = Истина Тогда
				рез = Ложь;
				Прервать;
			КонецЕсли;
			Если Справочники.ИндКод.НайтиПоНаименованию(с.укод).Пустая() = Истина Тогда
				рез = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		возврат рез;
	КонецФункции
	
	Процедура ОтразитьРасходы()
		// ++ obrv 12.11.18
		Если Расход = 0 Тогда
			Возврат
		КонецЕсли;
		
		Движение = Движения.Расходы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.ВидРасхода = Справочники.ВидыРасходов.НайтиПоКоду("000000003");
		Движение.Комментарий = "Расходы при продаже. Доумент № " + ЭтотОбъект.Номер;
		Движение.Сумма = Расход;
		// -- obrv 12.11.18
		
	КонецПроцедуры
	
	Процедура дт_ОбработкаПроведения(Отказ, РежимПроведения)
		
		УчетПоСкладам = дт_ОбщегоНазначенияКлиентСервер.УчетПоСкладам(Дата);
		
		Если Не УчетПоСкладам Тогда
			Возврат
		КонецЕсли;
		
		ДополнительныеСвойства.Вставить("ДатаДокументаСдвинутаВперед", Ложь); 
		ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
		
		
		ПараметрыПроведенияПродажа = Документы.ПродажаЗапчастей.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
		ПараметрыПроведенияСклад = Документы.ПродажаЗапчастей.ПодготовитьПараметрыПроведенияСклад(Ссылка, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		дт_ОбщегоНазначения.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		дт_Склад.ПодготовитьНаборыЗаписей(ЭтотОбъект);
		дт_Продажи.ПодготовитьНаборыЗаписей(ЭтотОбъект);
		дт_СебестоимостьТоваров.ПодготовитьНаборыЗаписей(ЭтотОбъект);
		
		// Формирование движений
		дт_Склад.ОтразитьДвижения(ПараметрыПроведенияСклад, Движения, Отказ);
		дт_Продажи.ОтразитьДвижения(ПараметрыПроведенияПродажа, Движения, Отказ);
		дт_СебестоимостьТоваров.ОтразитьДвижения(ПараметрыПроведенияПродажа, Движения, Отказ);
		ОтразитьРасходы();
		
		//Если в таблице есть транзитный склад: "НН Транзитная зона УЧЁТА отгрузки/сборки"
		Движения.ТоварыВТранзитнойЗоне.Записывать = Истина;
		Для Каждого ТекСтрокаТаблица Из Таблица Цикл
			Если ТекСтрокаТаблица.Склад = Справочники.Склады.НайтиПоКоду("000000014") Тогда 
				Движение = Движения.ТоварыВТранзитнойЗоне.Добавить();
				Движение.ВидДвижения  = ВидДвиженияНакопления.Расход;
				Движение.Период 	  = Дата;
				Движение.Номенклатура = ТекСтрокаТаблица.Товар;
				Движение.Склад 		  = ТекСтрокаТаблица.Склад;
				Движение.партия 	  = ТекСтрокаТаблица.Партия;
				Движение.Автомобиль   = ТекСтрокаТаблица.машина;
				Движение.Распоряжение = ПолучитьРаспоряжение(ТекСтрокаТаблица.Склад, ТекСтрокаТаблица.Товар,
				ТекСтрокаТаблица.Партия, ТекСтрокаТаблица.машина);
				Движение.Количество   = ТекСтрокаТаблица.Количество;
			КонецЕсли;
		КонецЦикла;
		//СергеевФВ 09/02/2023  000002680 Н
		Для Каждого ТекСтрокаТаблица Из Таблица Цикл
			Если ТекСтрокаТаблица.Склад = Справочники.Склады.НайтиПоКоду("000000017") Тогда 
				Возврат;
				Сообщить("С Транзитной зоны восстановления нельзя списать товар!");
			КонецЕсли;
		КонецЦикла;
		//СергеевФВ 09/02/2023  000002680 К
		Движения.Записать();
		
		ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСписанныеТовары", ПараметрыПроведенияСклад.ТаблицаСписанныеТовары);
		ДополнительныеСвойства.ДляПроведения.МоментКонтроля = Новый Граница(МоментВремени(), ВидГраницы.Включая);
		
		// Контроль отрицательных остаткок по регистрам накопления (только в рамках Д_Доработок)
		Документы.ПродажаЗапчастей.ВыполнитьКонтроль(ЭтотОбъект, ДополнительныеСвойства, Отказ);
		//
		Если Не Отказ Тогда
			ОтправитьУведомлениеКлиенту();
		КонецЕсли;
		
	КонецПроцедуры
	
	#КонецОбласти
	
	Процедура ПриЗаписи(Отказ)
		
		///+ГомзМА 18.10.2023
		ПродажаУжеЕсть = ПроверитьПродажу();
		
		Если Рекомендатель <> Справочники.Клиенты.ПустаяСсылка() Тогда
			Если НЕ ПродажаУжеЕсть Тогда
				СправочникОбъектРекомендатель = Рекомендатель.ПолучитьОбъект();
				СправочникОбъектРекомендатель.СтатусВТСпасибо = 1;
				НоваяСтрока = СправочникОбъектРекомендатель.ВТСпасибо.Добавить();
				НоваяСтрока.Покупатель = Клиент;
				НоваяСтрока.Продажа = Ссылка;
				НоваяСтрока.СуммаПродажи = ИтогоРекв;
				НоваяСтрока.НачисленоСПродажи = ИтогоРекв * 0.05;
				СправочникОбъектРекомендатель.Записать();
				
				СправочникОбъектПокупатель = Клиент.ПолучитьОбъект();
				СправочникОбъектПокупатель.СтатусВТСпасибо = 2;
				СправочникОбъектПокупатель.Записать();
			КонецЕсли;
		КонецЕсли;
		///-ГомзМА 18.10.2023
		
		
	КонецПроцедуры
	
	&НаСервере
	Функция ПроверитьПродажу()
		
		///+ГомзМА 18.10.2023
		Результат = Ложь;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	КлиентыВТСпасибо.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Клиенты.ВТСпасибо КАК КлиентыВТСпасибо
		|ГДЕ
		|	КлиентыВТСпасибо.Продажа = &Продажа";
		
		Запрос.УстановитьПараметр("Продажа", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
		Если РезультатЗапроса.Количество() > 0 Тогда
			Результат = Истина;
		КонецЕсли;
		
		Возврат Результат;
		///-ГомзМА 18.10.2023
		
	КонецФункции // ПроверитьПродажу()
	
	
	#Область ОбработчикиСобытий
	
	Процедура ОбработкаПроведения(Отказ, Режим)
		
		СоздатьКаталог("C:\Users\serv_sql\Nextcloud\Продажи\"+Номер);

		///{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
		// Данный фрагмент построен конструктором.
		// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
		Если СтатусПродажи <> Перечисления.СтатусыПродажи.Сорвалась тогда
			// ++ obrv 04.09.18
			УчетПоСкладам = дт_ОбщегоНазначенияКлиентСервер.УчетПоСкладам(Дата);
			// -- obrv 04.09.18
			
			// регистр РегистрНакопления1 Расход
			Если ВозвратТовара <> Истина Тогда
				//		Если ВездеЕстьКод() = Ложь Тогда
				//			Отказ = Истина;
				//			возврат;
				//		КонецЕсли;
				
				// ++ obrv 06.09.18
				Если Не УчетПоСкладам Тогда
					// -- obrv 06.09.18
					Движения.РегистрНакопления1.Записывать = Истина;
					Для Каждого ТекСтрокаТаблица Из Таблица Цикл
						
						Если Не ТекСтрокаТаблица.СтатусТовара Тогда
							Продолжить
						КонецЕсли;
						
						//Если ТекСтрокаТаблица.Отменено Тогда
						//	Продолжить
						//КонецЕсли;
						
						Движение = Движения.РегистрНакопления1.Добавить();
						Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
						Движение.Период 	 = Дата;
						Движение.Товар  	 = ТекСтрокаТаблица.Товар;
						Движение.Склад  	 = ТекСтрокаТаблица.Склад;
						Движение.машина 	 = ТекСтрокаТаблица.машина;
						Движение.индкод 	 = ТекСтрокаТаблица.Партия;
						//			Если ЗначениеЗаполнено(ТекСтрокаТаблица.Партия) Тогда
						//				Движение.индкод = ТекСтрокаТаблица.Партия;
						//			Иначе 
						//				Движение.индкод = Справочники.ИндКод.ПолучитьПартиюПоКоду(ТекСтрокаТаблица.укод, ТекСтрокаТаблица.Товар, Неопределено, Отказ);//Справочники.ИндКод.НайтиПоНаименованию(ТекСтрокаТаблица.укод);
						//			КонецЕсли;	
						Движение.Колво = ТекСтрокаТаблица.Количество; 
						
						//Движение.Стеллаж = ТекСтрокаТаблица.Стеллаж;
					КонецЦикла;
					
					Движения.ТоварыВТранзитнойЗоне.Записывать = Истина;
					Для Каждого ТекСтрокаТаблица Из Таблица Цикл
						Если ТекСтрокаТаблица.Склад = Справочники.Склады.НайтиПоКоду("000000017") тогда
							Возврат;
							Сообщить("С Транзитной зоны восстановления нельзя списать товар!");
							//Движение = Движения.ТоварыВТранзитнойЗоне.Добавить();
							//Движение.ВидДвижения  = ВидДвиженияНакопления.Расход;
							//Движение.Период 	  = Дата;
							//Движение.Номенклатура = ТекСтрокаТаблица.Товар;
							//Движение.Склад 		  = ТекСтрокаТаблица.Склад;
							//Движение.партия 	  = ТекСтрокаТаблица.Партия;
							//Движение.Автомобиль   = ТекСтрокаТаблица.машина;
							//Движение.Распоряжение = ТекСтрокаТаблица.ПолучитьРаспоряжение(ТекСтрокаТаблица.Склад, ТекСтрокаТаблица.Товар, ТекСтрокаТаблица.Партия, ТекСтрокаТаблица.машина);
							//Движение.Количество   = ТекСтрокаТаблица.Количество;
						КонецЕсли;
					КонецЦикла;
					
					// ++ obrv 06.09.18
				КонецЕсли;
				// -- obrv 06.09.18
				
				// регистр ИнформацияОПродажах Приход
				ИтогоОбщ = 0;
				СкидкаОбщ = 0;
				Если Оплачено = Истина Тогда
					Движения.ИнформацияОПродажах.Записывать = Истина;
					Для Каждого ТекСтрокаТаблица Из Таблица Цикл
						
						Если ТекСтрокаТаблица.Отменено ИЛИ НЕ ТекСтрокаТаблица.СтатусТовара Тогда
							Продолжить
						КонецЕсли;
						
						Движение = Движения.ИнформацияОПродажах.Добавить();
						Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
						Движение.Период = Дата;
						Движение.Товар = ТекСтрокаТаблица.Товар;
						Движение.машина = ТекСтрокаТаблица.машина;
						Скидка = 0;
						ИтогоОбщ = ИтогоОбщ + ТекСтрокаТаблица.Цена*ТекСтрокаТаблица.Количество;
						Если ТекСтрокаТаблица.Скидка <> Null И ТекСтрокаТаблица.Скидка > 0 Тогда
							Скидка = ТекСтрокаТаблица.Скидка;
							СкидкаОбщ = СкидкаОбщ + ТекСтрокаТаблица.Скидка;
						Иначе
							Скидка = ТекСтрокаТаблица.Цена*(Клиент.Скидка/100);
							СкидкаОбщ = СкидкаОбщ + (ТекСтрокаТаблица.Цена*ТекСтрокаТаблица.Количество)*(Клиент.Скидка/100);
						КонецЕсли;
						Движение.цена = ТекСтрокаТаблица.Цена-Скидка;
						Движение.колво = ТекСтрокаТаблица.Количество;
					КонецЦикла;
				КонецЕсли;	
				
				Движения.Расходы.Записывать = Истина;
				// ++ obrv 12.11.18
				//Движение = Движения.Расходы.Добавить();
				//Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				//Движение.Период = Дата;
				//Движение.ВидРасхода = Справочники.ВидыРасходов.НайтиПоКоду("000000003");
				//Движение.Комментарий = "Расходы при продаже. Доумент № " + ЭтотОбъект.Номер;
				//Движение.Сумма = Расход;
				ОтразитьРасходы();
				// -- obrv 12.11.18
				
				ИтогоРекв = ИтогоОбщ - СкидкаОбщ - Откат;
				///+ГомзМА 18.10.2023
			ИначеЕсли Рекомендатель <> Справочники.Клиенты.ПустаяСсылка() Тогда
				ИтогоРекв = ИтогоРекв - СкидкаВТСпасибо;
				///-ГомзМА 18.10.2023
			Иначе
				ИтогоРекв = ИтогоРекв + СуммаВозврат;
			КонецЕсли;
			
			
			//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
			
			дт_ОбработкаПроведения(Отказ, Режим);
		КонецЕсли;
		
		//Волков ИО 07.12.23 ++
		// РН БалансКлиента Расход
		// Комменчу, для раб базы
		//Если СписатьСБалансаКлиента Тогда 
		//	Движения.БалансКлиента.Записывать = Истина;
		//	Движение = Движения.БалансКлиента.Добавить();
		//	движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		//	Движение.Период = Дата;
		//	Движение.Клиент = Клиент;
		//	Движение.Баланс = ИтогоБезнал;
		//КонецЕсли;	
		//Волков ИО 07.12.23 --
		
		
		
		//////////////////////////////////Запись движений происходит из документов Списаний////////////////////////////////////////////////	
		/////+ГомзМА 11.05.2023 
		//// Формирование движения ТМЦ
		//Если ЗначениеЗаполнено(ТМЦ) Тогда
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
		//Отказ = РегистрыНакопления.ДвижениеТМЦСкладСнабжение.ЕстьОтрицательныеОстатки(Ссылка, Дата, ТекСтрокаТМЦ.СкладСписания);
		//	
		//КонецЕсли;
		/////-ГомзМА 11.05.2023
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		ЭтапированиеЗаявки();
		
		//Добавление бонусов в карточку Клиенты
		 
		Если БылоСписаниеБонусов = Истина Тогда
			ИтогоРекв = дт_ОбщегоНазначения.ИтоговаяСумма(ЭтотОбъект, "Таблица", "Отменено") - СколькоСписать;
			
		Иначе 
			ИтогоРекв = дт_ОбщегоНазначения.ИтоговаяСумма(ЭтотОбъект, "Таблица", "Отменено");
		КонецЕсли;
			
		Если ИтогоРекв <= 0 И БылоСписаниеБонусов = Истина Тогда
			ИтогоРекв = 0;
		КонецЕсли;
		
		
			КлиентОбъект = Клиент.ПолучитьОбъект();
			ЕстьБонусыЗаЭтуПродажу = Ложь;
			 
			
			 Для каждого Строка Из КлиентОбъект.БонусыКлиента Цикл 
			 	Если Строка.Продажа = Ссылка  Тогда
			 		ЕстьБонусыЗаЭтуПродажу = Истина; 
			 	
			 	КонецЕсли;
			 КонецЦикла; 
			 
			 Если ЕстьБонусыЗаЭтуПродажу = Ложь Тогда
			 	НоваяСтрокаТЧ = КлиентОбъект.БонусыКлиента.Добавить();
				НоваяСтрокаТЧ.Дата = Дата;
				НоваяСтрокаТЧ.Продажа = Ссылка;
			
				НоваяСтрокаТЧ.СуммаПродажи = ИтогоРекв;
				СуммаБонусов = ИтогоРекв * 0.05;
				НоваяСтрокаТЧ.Бонусы = Цел(СуммаБонусов);
				НоваяСтрокаТЧ.СуммаБонусовДоСписания = Цел(СуммаБонусов);
				НоваяСтрокаТЧ.Списаны = Ложь;
				
			 Иначе
			 	Для каждого СтрокаТЧ из КлиентОбъект.БонусыКлиента Цикл
			 		Если СтрокаТЧ.Продажа = Ссылка И СтрокаТЧ.Бонусы = СтрокаТЧ.СуммаБонусовДоСписания И СтрокаТЧ.Списаны = Ложь Тогда
						СтрокаТЧ.СуммаПродажи = ИтогоРекв;
						СуммаБонусов = ИтогоРекв * 0.05;
						СтрокаТЧ.Бонусы = Цел(СуммаБонусов);
						СтрокаТЧ.СуммаБонусовДоСписания = Цел(СуммаБонусов);
			 		ИначеЕсли СтрокаТЧ.Продажа = Ссылка И СтрокаТЧ.Бонусы <> СтрокаТЧ.СуммаБонусовДоСписания Тогда
			 			СколькоБонусовСейчасВСтроке = СтрокаТЧ.Бонусы;
			 			СтрокаТЧ.СуммаПродажи = ИтогоРекв;
			 			СуммаБонусов = (ИтогоРекв * 0.05) - СколькоБонусовСейчасВСтроке;
			 			СтрокаТЧ.Бонусы = Цел(СуммаБонусов);
						СтрокаТЧ.СуммаБонусовДоСписания = Цел(СуммаБонусов);
			 		КонецЕсли;
			 	КонецЦикла;
			
			 	
			 	
			КонецЕсли;
			
		КлиентОбъект.БонусыКлиента.Сортировать("Дата");
		КлиентОбъект.Записать();
		
		// ++ МазинЕС 09-07-2024 
		МассивДат= Новый Массив; 
		Если не ЗначениеЗаполнено(ДатаОтгрузкиСоСклада) Тогда 
		ПроставтьДатуОтгрузкиСоСклада = Ложь;
		Для Каждого Строка из Таблица Цикл 
			
			Если Строка.СтатусТовара Тогда
				ПроставтьДатуОтгрузкиСоСклада = Истина;
			МассивДат.Добавить(Строка.ДатаВыдачи);	
			Иначе 
				ПроставтьДатуОтгрузкиСоСклада  = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ПроставтьДатуОтгрузкиСоСклада Тогда
				Для Каждого Строка ИЗ МассивДат Цикл 
				ЕСли ДатаОтгрузкиСоСклада < Строка Тогда  
					ДатаОтгрузкиСоСклада =Строка;
				КонецЕсли 
				КонецЦикла; 
			КонецЕсли;
		Записать(); 
	КонецЕсли;	
	
	// -- МазинЕС 09-07-2024	

КонецПроцедуры
	
	Процедура ЭтапированиеЗаявки()
		Выдача = Истина;
		Для каждого стр из Таблица Цикл
			Если Не стр.СтатусТовара тогда
				Выдача = Ложь;	
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		НаборЗаписей = РегистрыСведений.ЭтапированиеЗаказа.СоздатьНаборЗаписей();  			
		НаборЗаписей.Отбор.Заявка.Установить(ЗаказКлиента);
		НаборЗаписей.Прочитать(); 
		
		Если НаборЗаписей.Количество() = 0 Тогда
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Заявка = ЗаказКлиента;
			НоваяЗапись.ЗаявкаСформирована = Истина;
			
		ИначеЕсли НаборЗаписей.Количество() = 1 Тогда
			
			НоваяЗапись = НаборЗаписей[0]; 		
			
		КонецЕсли; 
		
		
		НоваяЗапись.Продажа = Ссылка; 
		НоваяЗапись.ВыписанаПродажа = Истина;
		НоваяЗапись.НаличиеПодтверждено = Истина;
		НоваяЗапись.ЗаявкаВРаботе = Истина;
		НоваяЗапись.ТоварВыданСоСклада = Выдача;
		
		Если Самовывоз тогда
			НоваяЗапись.ТоварУпакован        = истина;
			НоваяЗапись.ТоварПринятВТК       = истина;
			НоваяЗапись.ТоварПринятКОтправке = истина;
			НоваяЗапись.ТоварПолученКлиентом = истина;	
		ИначеЕсли СтатусДоставки = Перечисления.СтатусОтправки.Собран Тогда
			НоваяЗапись.ТоварУпакован        = истина;
			НоваяЗапись.ТоварПринятКОтправке = истина;	
		ИначеЕсли СтатусДоставки = Перечисления.СтатусОтправки.Отправлен Тогда
			
		КонецЕсли; 
		
		НоваяЗапись.ОплатаПоступила	= Оплачено;
		
		
		НаборЗаписей.Записать();
		
	КонецПроцедуры 
	
	Процедура ДобавитьСтрокиТоваров(КолВотовара,Текстрока) 
		
		//Волков ИО 22.02.24 ++
		НСтрока = 0;
		Пока НСтрока < КолВотовара-1 Цикл
			
			НоваяСтрока = ЭтотОбъект.Таблица.добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Текстрока);
			
			Если ЭтотОбъект.НачислятьНДС Тогда
				СуммаНДС = НоваяСтрока.Цена * 0.2;	
				НоваяСтрока.Сумма = (НоваяСтрока.Цена + СуммаНДС) * НоваяСтрока.Количество;
				НоваяСтрока.СуммаНДС = СуммаНДС * НоваяСтрока.Количество;
			Иначе
				НоваяСтрока.Сумма = НоваяСтрока.Цена * НоваяСтрока.Количество;
				НоваяСтрока.СуммаНДС = 0;
			КонецЕсли;
			
			НСтрока = НСтрока + 1;
		КонецЦикла;
		//Волков ИО 22.02.24 --	
		
	КонецПроцедуры
	
	Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
		WTPanel = Справочники.СтатусыWT.НайтиПоНаименованию("Продажа");
		
		Если Не ЗначениеЗаполнено(КтоПродал) Тогда
			КтоПродал = Пользователи.ТекущийПользователь();
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПредварительныйСчет") Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПредварительныйСчет.Ссылка КАК Основание,
			|	ПредварительныйСчет.Клиент КАК Клиент,
			|	ПредварительныйСчет.Комментарий КАК Комментарий,
			|	ПредварительныйСчет.Доставка КАК Доставка,
			|	ПредварительныйСчет.Расход КАК Расход,
			|	ПредварительныйСчет.СрокПроверки КАК СрокПроверки,
			|	ПредварительныйСчет.Организация КАК Организация,
			|	ПредварительныйСчет.ИтогоРекв КАК ИтогоРекв,
			|	ПредварительныйСчет.Оплачено КАК Оплачено,
			|	ПредварительныйСчет.УжеОплачено КАК УжеОплачено,
			|	ПредварительныйСчет.Откат КАК Откат,
			|	ПредварительныйСчет.КомуОткат КАК КомуОткат,
			|	ПредварительныйСчет.ОтданоМарату КАК ОтданоМарату,
			|	ПредварительныйСчет.ИтогоБезнал КАК ИтогоБезнал,
			|	ПредварительныйСчет.АртикулВНазвании КАК АртикулВНазвании,
			|	ПредварительныйСчет.ВычитатьИзСуммы КАК ВычитатьИзСуммы,
			|	ПредварительныйСчет.ПотеряНаОбналичку КАК ПотеряНаОбналичку,
			|	ПредварительныйСчет.ОстатокДенег КАК ОстатокДенег,
			|	ПредварительныйСчет.ВозвратТовара КАК ВозвратТовара,
			|	ПредварительныйСчет.СуммаВозврат КАК СуммаВозврат,
			|	ПредварительныйСчет.ТранспортнаяКомпания КАК ТранспортнаяКомпания,
			|	ПредварительныйСчет.Вес КАК Вес,
			|	ПредварительныйСчет.Объем КАК Объем,
			|	ПредварительныйСчет.КоличествоМест КАК КоличествоМест,
			|	ПредварительныйСчет.ГородОтправки КАК ГородОтправки,
			|	ПредварительныйСчет.РегионПолучения КАК РегионПолучения,
			|	ПредварительныйСчет.ГородПолучения КАК ГородПолучения,
			|	ПредварительныйСчет.СтоимостьДоставки КАК СтоимостьДоставки,
			|	ПредварительныйСчет.ЕстьДоставка КАК ЕстьДоставка,
			|	ПредварительныйСчет.ДоставкаНеЗаполнена КАК ДоставкаНеЗаполнена,
			|	ПредварительныйСчет.Самовывоз КАК Самовывоз,
			|	ПредварительныйСчет.СтранаПолучения КАК СтранаПолучения,
			|	ПредварительныйСчет.Новые КАК Новые,
			|	ПредварительныйСчет.Скидка КАК Скидка,
			|	ПредварительныйСчет.КоммДост КАК КоммДост,
			|	ПредварительныйСчет.НомерПП КАК НомерПП,
			|	ПредварительныйСчет.TipOplati КАК TipOplati,
			|	ПредварительныйСчет.доставкаКлиент КАК доставкаКлиент,
			|	ПредварительныйСчет.частный КАК частный,
			|	ПредварительныйСчет.НаименованиеИлиФИО КАК НаименованиеИлиФИО,
			|	ПредварительныйСчет.ИНН КАК ИНН,
			|	ПредварительныйСчет.Телефон КАК Телефон,
			|	ПредварительныйСчет.Паспорт КАК Паспорт,
			|	ПредварительныйСчет.Прописка КАК Прописка,
			|	ПредварительныйСчет.СтатусДоставки КАК СтатусДоставки,
			|	ПредварительныйСчет.ДоговорКонтрагента КАК ДоговорКонтрагента,
			|	ПредварительныйСчет.БезДоговора КАК БезДоговора,
			|	ПредварительныйСчет.Таблица.(
			|		Товар КАК Товар,
			|		Количество КАК Количество,
			|		ВЫБОР
			|			КОГДА ПредварительныйСчет.Организация.Налог > 0
			|				ТОГДА ПредварительныйСчет.Таблица.Сумма / ПредварительныйСчет.Таблица.Количество / 1.2
			|			ИНАЧЕ ПредварительныйСчет.Таблица.Цена
			|		КОНЕЦ КАК Цена,
			|		Скидка КАК Скидка,
			|		машина КАК машина,
			|		цена1 КАК цена1,
			|		Комментарий КАК Комментарий,
			|		Сумма КАК Сумма,
			|		ВЫБОР
			|			КОГДА ПредварительныйСчет.Организация.Налог > 0
			|				ТОГДА ПредварительныйСчет.Таблица.Сумма / ПредварительныйСчет.Таблица.Количество / 1.2 * 0.2 * ПредварительныйСчет.Таблица.Количество
			|			ИНАЧЕ 0
			|		КОНЕЦ КАК СуммаНДС,
			|		Партия КАК Партия
			|	) КАК Таблица,
			|	ПредварительныйСчет.УслугиДоствка.(
			|		Услуга КАК Услуга,
			|		Цена КАК Цена
			|	) КАК УслугиДоствка,
			|	ПредварительныйСчет.Основание КАК ОснованиеЗаявка
			|ИЗ
			|	Документ.ПредварительныйСчет КАК ПредварительныйСчет
			|ГДЕ
			|	ПредварительныйСчет.Ссылка = &Ссылка";
			
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				ТабличнаяЧастьТовары = ВыборкаДетальныеЗаписи.Таблица.Выгрузить();
				ТабличнаяЧастьУслуги = ВыборкаДетальныеЗаписи.УслугиДоствка.Выгрузить();
				
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаДетальныеЗаписи, , "УслугиДоствка,Таблица");
				
				ЗаказКлиента = ВыборкаДетальныеЗаписи.ОснованиеЗаявка;
				Склад = Справочники.Склады.НайтиПоКоду("000000002");
				
				Таблица.Загрузить(ТабличнаяЧастьТовары);
				УслугиДоствка.Загрузить(ТабличнаяЧастьУслуги);
			КонецЦикла;
			
			///+ГомзМА 18.12.2023
			Для каждого СтрокаТЧ Из Таблица Цикл
				Если ЗначениеЗаполнено(СтрокаТЧ.Партия) Тогда
					
					СтрокаТЧ.машина = ПолучитьМашинуПоИндкоду(СтрокаТЧ.Партия);
					
				КонецЕсли;
			КонецЦикла;
			///-ГомзМА 18.12.2023
			
		//Волков ИО 22.02.24 ++
		КолВоТовара = СтрокаТЧ.Количество;
		
		Если  КолВоТовара > 1 Тогда
			СтрокаТЧ.Количество = 1;
			СтрокаТЧ.Сумма = 0;
			ДобавитьСтрокиТоваров(КолВоТовара, СтрокаТЧ);
		КонецЕсли;
		//Волков ИО 22.02.24 --
			
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			
			//ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, ДанныеЗаполнения);
			Продажа = ПроверкаПродаж(ДанныеЗаполнения); 
			Если Продажа.ссылка = неопределено Тогда
				Запрос = Новый Запрос;
				Запрос.Текст =
				"ВЫБРАТЬ
				|	Док.Клиент КАК Клиент,
				|	Док.Комментарий КАК Комментарий,
				|	Док.Проект КАК Проект,
				|	Док.Склад КАК Склад,
				|	Док.Ссылка КАК ЗаказКлиента,
				|	Док.СуммаДокументаНДС КАК СуммаДокументаНДС,
				|	Док.НачислятьНДС КАК НачислятьНДС
				|ПОМЕСТИТЬ втШапка
				|ИЗ
				|	Документ.ЗаказКлиента КАК Док
				|ГДЕ
				|	Док.Ссылка = &Ссылка
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	втШапка.Клиент КАК Клиент,
				|	втШапка.Комментарий КАК Комментарий,
				|	втШапка.Проект КАК Проект,
				|	втШапка.Склад КАК Склад,
				|	втШапка.ЗаказКлиента КАК ЗаказКлиента,
				|	втШапка.СуммаДокументаНДС КАК СуммаДокументаНДС,
				|	втШапка.НачислятьНДС КАК НачислятьНДС
				|ИЗ
				|	втШапка КАК втШапка
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ЗаказКлиентаТовары.НомерСтроки КАК НомерСтроки,
				|	ЗаказКлиентаТовары.Номенклатура КАК Товар,
				|	ЗаказКлиентаТовары.Количество КАК Количество,
				|	ЗаказКлиентаТовары.Цена КАК Цена,
				|	ЗаказКлиентаТовары.Сумма КАК Сумма,
				|	втШапка.Склад КАК Склад,
				|	втШапка.СуммаДокументаНДС КАК СуммаДокументаНДС,
				|	втШапка.НачислятьНДС КАК НачислятьНДС,
				|	ЗаказКлиентаТовары.СуммаНДС КАК СуммаНДС,
				|	ЗаказКлиентаТовары.Партия КАК Партия
				|ИЗ
				|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
				|		ЛЕВОЕ СОЕДИНЕНИЕ втШапка КАК втШапка
				|		ПО (ИСТИНА)
				|ГДЕ
				|	ЗаказКлиентаТовары.Ссылка = &Ссылка
				|	И НЕ ЗаказКлиентаТовары.Отменено
				|
				|УПОРЯДОЧИТЬ ПО
				|	НомерСтроки";
				
				
				Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
				
				РезультатЗапроса = Запрос.ВыполнитьПакет();
				
				Шапка = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(РезультатЗапроса[РезультатЗапроса.Количество() - 2].Выгрузить()[0]);
				
				ЗаполнениеДокументов.Заполнить(ЭтотОбъект, Шапка, Ложь);
				Таблица.Загрузить(РезультатЗапроса[РезультатЗапроса.Количество() - 1].Выгрузить());
			Иначе
				СтандартнаяОбработка = ложь;
				Возврат;
				
			КонецЕсли;
			
			///+ГомзМА 18.12.2023
			Для каждого СтрокаТЧ Из Таблица Цикл
				Если ЗначениеЗаполнено(СтрокаТЧ.Партия) Тогда
					СтрокаТЧ.машина = ПолучитьМашинуПоИндкоду(СтрокаТЧ.Партия);
				КонецЕсли;
			КонецЦикла;
			///-ГомзМА 18.12.2023
			
		КонецЕсли;
		
		СтатусПродажи = Перечисления.СтатусыПродажи.Актуальная;	
		
		///+ГомзМА 18.12.2023
		Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
			Если НЕ ЗначениеЗаполнено(СтатусОбработки) Тогда
				СтатусОбработки = Перечисления.СтатусыОбработкиЗаявок.Обработано;
			КонецЕсли;
		КонецЕсли;
		///-ГомзМА 18.12.2023
		
		///+ГомзМА 26.12.2023
		Если WTpanel = Справочники.СтатусыWT.ПустаяСсылка() Тогда
			WTpanel = Справочники.СтатусыWT.НайтиПоКоду("000000004");
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ПодстатусОбработки) Тогда
			ПодстатусОбработки = Перечисления.ПодстатусыОбработкиЗаявок.Ожидание;
		КонецЕсли;
		///-ГомзМА 26.12.2023
		
		
	КонецПроцедуры
	
	
	
	
	Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
		
		МассивНепроверяемыхРеквизитов = Новый Массив();
		
		// Договоры
		Если БезДоговора Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		КонецЕсли;
		
		
		// Складской учет
		УчетПоСкладам = дт_ОбщегоНазначенияКлиентСервер.УчетПоСкладам(Дата);
		
		Если НЕ УчетПоСкладам Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Склад");
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.Склад");
		КонецЕсли;
		
		Если НЕ (ЕстьДоставка И НЕ Самовывоз) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Водитель");
		КонецЕсли;
		
		Если НЕ ПолучитьФункциональнуюОпцию("дт_ОтгрузкаСРазныхСкладов") Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.Склад");
		КонецЕсли;
		
		///+ГомзМА 10.01.2024
		Если Дата < '20180901' Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.Партия");
		КонецЕсли;
		
		Если Дата < '20180901' Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ЗаказКлиента");
		КонецЕсли;
		
		Если Дата < '20230715' Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ОжидаемаяДатаВыплаты");
		КонецЕсли;
		///-ГомзМА 10.01.2024
		
		//ЕстьНДС = Ложь;
		//Если ЗначениеЗаполнено(Организация) И Не ЭтоНовый() И Дата >= '20180201' Тогда
		//	
		//	ЕстьНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЕстьУчетНДС");
		//	
		//КонецЕсли;
		//
		//Если Не ЕстьНДС Тогда
		//	
		//	МассивНепроверяемыхРеквизитов.Добавить("НомерУПД");
		//	МассивНепроверяемыхРеквизитов.Добавить("ДатаУПД");
		//	
		//КонецЕсли;
		
		// ЗаказКлиента
		Если Дата < '20220309' Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ЗаказКлиента");
		КонецЕсли;
		
		///+ГомзМА 25.12.2023
		// Проверка на Услугу
		ЭтоУслуга = Ложь;
		Для каждого СтрокаТЧ Из Таблица Цикл
			Если СтрокаТЧ.Товар.Подкатегория2 = Справочники.Категории.НайтиПоКоду("000000331") Тогда
				ЭтоУслуга = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;
		
		Если ЭтоУслуга Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.Партия");
			
			Для каждого СтрокаТЧ Из Таблица Цикл
				Если СтрокаТЧ.Товар.Подкатегория2 <> Справочники.Категории.НайтиПоКоду("000000331") И
					СтрокаТЧ.Партия = Справочники.ИндКод.ПустаяСсылка() Тогда
					Отказ = Истина;
					Сообщить("Не заполнена партия в строке №" + СтрокаТЧ.НомерСтроки);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		///-ГомзМА 25.12.2023
		
		
		// Проверка цен
		дт_Ценообразование.ПроверитьЦены(ЭтотОбъект, "Таблица");
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
	КонецПроцедуры
	
	Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
		ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
		ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
		
		Если ОбменДанными.Загрузка Тогда
			Возврат
		КонецЕсли;
		
		Если ПометкаУдаления Тогда
			НомерУПД = "";
			ТоварнаяНакладная = "";
			Возврат
		КонецЕсли;
		
		Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
			Возврат
		КонецЕсли;
		
		Если НЕ дт_Нумерация.НомерУникален(ЭтотОбъект, Истина, Истина, Истина, "ТоварнаяНакладная", Отказ) Тогда
			Возврат
		КонецЕсли;
		
		
		ЕстьНДС = Ложь;
		Если ЗначениеЗаполнено(Организация) Тогда
			
			ЕстьНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЕстьУчетНДС");
			
		КонецЕсли;
		
		Если ЕстьНДС Тогда
			//Если Не ЗначениеЗаполнено(ДатаУПД) Тогда
			//	ДатаУПД = Дата;
			//КонецЕсли;
			
			Если Не ЗначениеЗаполнено(НомерУПД) Тогда
				//НомерУПД = дт_Нумерация.СвободныйНомерДокумента(
				//	Метаданные().Имя, 
				//	ДатаУПД, 
				//	дт_ОбщегоНазначения.ПрефиксОрганизации(Организация),
				//	"НомерУПД"
				//);
			Иначе
				Если НЕ дт_Нумерация.НомерУникален(ЭтотОбъект, Истина, Истина, Истина, "НомерУПД", Отказ) Тогда
					Возврат
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ (ЕстьДоставка И Не Самовывоз) Тогда
			Водитель = Неопределено;
		КонецЕсли;
		
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
		
		Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			УстановитьСтатусПредыдущейВерсии();
		КонецЕсли;
		
		ДополнительныеСвойства.Вставить("ЭтоНовый",                    ЭтоНовый()); 
		
		
		//ИтогоРекв = дт_ОбщегоНазначения.ИтоговаяСумма(ЭтотОбъект, "Таблица", "Отменено");
		
		///+ГомзМА 18.10.2023
		Если Рекомендатель <> Справочники.Клиенты.ПустаяСсылка() Тогда
			//ИтогоРекв = ИтогоРекв - СкидкаВТСпасибо;
		КонецЕсли;
		///-ГомзМА 18.10.2023
		
		///+ГомзМА 15.08.2023
		Если Таблица.Количество() <> 0 Тогда
			Для каждого СтрокаТЧ Из Таблица Цикл
				СсылкаНаДокумент = ПолучитьСсылкуНаДокументРасКомплектовка(СтрокаТЧ.Партия);
				Если СсылкаНаДокумент <> Неопределено Тогда
					ДокОбъект = СсылкаНаДокумент.ПолучитьОбъект();
					ДокОбъект.ДетальПродана = Истина;
					ДокОбъект.Записать();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		///-ГомзМА 15.08.2023
		
		
		
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
	
	
	Процедура ОбработкаУдаленияПроведения(Отказ)
		ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
		Движения.Записать();
		
		КлиентОбъект = Клиент.ПолучитьОбъект();
		
		Для каждого СтрокаТЧ Из КлиентОбъект.БонусыКлиента Цикл
			Если СтрокаТЧ.Продажа = Ссылка Тогда
				КлиентОбъект.БонусыКлиента.Удалить(СтрокаТЧ.НомерСтроки - 1);
			КонецЕсли;
		КонецЦикла;
		
		КлиентОбъект.Записать();
		
	КонецПроцедуры
	
	Процедура ПриКопировании(ОбъектКопирования)
		
		НомерУПД = "";
		ДатаУПД = Дата(1, 1, 1);
		
	КонецПроцедуры
	
	#КонецОбласти
	
	#Область СлужебныеПроцедурыИФункции
	
	Процедура УстановитьСтатусПредыдущейВерсии() Экспорт
		
		Если ЭтоНовый() Тогда
			Возврат
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПродажаЗапчастей.СтатусДоставки,
		|	ПродажаЗапчастей.Проведен
		|ИЗ
		|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
		|ГДЕ
		|	ПродажаЗапчастей.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		СтатусДоставкиИзменен = Ложь;
		ПризнакПроведенияИзменен = Ложь;
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			СтатусДоставкиИзменен = ВыборкаДетальныеЗаписи.СтатусДоставки <> СтатусДоставки;
			ПризнакПроведенияИзменен = НЕ ВыборкаДетальныеЗаписи.Проведен;
		КонецЕсли;
		
		ДополнительныеСвойства.Вставить("СтатусДоставкиИзменен", СтатусДоставкиИзменен);
		ДополнительныеСвойства.Вставить("ПризнакПроведенияИзменен", ПризнакПроведенияИзменен);
		
	КонецПроцедуры
	
	Процедура ОтправитьУведомлениеКлиенту() Экспорт
		
		Если (ДополнительныеСвойства.Свойство("ЭтоНовый") 
			И ДополнительныеСвойства.ЭтоНовый)
			ИЛИ (ДополнительныеСвойства.Свойство("ПризнакПроведенияИзменен") 
			И ДополнительныеСвойства.ПризнакПроведенияИзменен) Тогда
			
			ТекстСообщения = СтрШаблон("Ваш заказ №%1 поступил в работу", дт_ПрефиксацияКлиентСервер.НомерНаПечать(Номер));
			
		ИначеЕсли ДополнительныеСвойства.Свойство("СтатусДоставкиИзменен")
			И ДополнительныеСвойства.СтатусДоставкиИзменен Тогда
			
			ТекстСообщения = СтрШаблон("Статус вашего заказа %1", СтатусДоставки);
			
		Иначе
			Возврат;
		КонецЕслИ;
		
		
		дт_УведомленияСМС.ОтправитьСМСКлиенту(Клиент, ТекстСообщения);
		
	КонецПроцедуры
	
	Функция ПолучитьМашинуПоИндкоду(Индкод)
		
		///+ГомзМА 18.12.2023
		Результат = Неопределено;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РегистрНакопления1Остатки.машина КАК машина
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
		|ГДЕ
		|	РегистрНакопления1Остатки.индкод = &индкод";
		
		Запрос.УстановитьПараметр("индкод", индкод);
		
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
		Если РезультатЗапроса.Количество() > 0 Тогда
			РезультатЗапроса.Следующий();
			Результат = РезультатЗапроса.машина;
		КонецЕсли;
		
		Возврат Результат;
		///-ГомзМА 18.12.2023
		
	КонецФункции // ПолучитьМашинуПоИндкоду()
	
	
	#КонецОбласти
	
	Функция ПроверкаПродаж(Заявка)
		Запрос = Новый Запрос;
		запрос.Текст = "ВЫБРАТЬ
		|	ПродажаЗапчастей.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
		|ГДЕ
		|	ПродажаЗапчастей.ЗаказКлиента = &ЗаказКлиента";
		Запрос.УстановитьПараметр("ЗаказКлиента",Заявка);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		Возврат Выборка;
		
	КонецФункции
	
#КонецЕсли
Функция ПолучитьРаспоряжение(Склад, Номенклатура, Партия, Автомобиль)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТоварыВТранзитнойЗоне.Распоряжение КАК Распоряжение
	|ИЗ
	|	РегистрНакопления.ТоварыВТранзитнойЗоне КАК ТоварыВТранзитнойЗоне
	|ГДЕ
	|	ТоварыВТранзитнойЗоне.Склад 		 = &Склад
	|	И ТоварыВТранзитнойЗоне.Номенклатура = &Номенклатура
	|	И ТоварыВТранзитнойЗоне.Партия 		 = &Партия
	|	И ТоварыВТранзитнойЗоне.Автомобиль 	 = &Автомобиль";
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Партия", Партия);
	Запрос.УстановитьПараметр("Автомобиль", Автомобиль);
	Распоряжение = Запрос.Выполнить().Выбрать();
	Распоряжение.Следующий();
	Возврат Распоряжение.Распоряжение;
КонецФункции;



