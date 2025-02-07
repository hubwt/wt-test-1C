Процедура ПередЗаписью(Отказ, Замещение)
/// Комлев 02/09/24 +++

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
// ++ МазинЕС Если из ячейки РВР перенести деталь на ячейку НЕ РВР то деталь удалится из ЗакзНаряда
	Для Каждого Стр Из ЭтотОбъект Цикл
		
		Если СтрНайти(Строка(Стр.Стеллаж), "yachejka RVR") = 0 И СтрНайти(Строка(Стр.Стеллаж), "Сервисные услуги") = 0 Тогда
				
				ЗапросПоПартии = Новый Запрос;
				ЗапросПоПартии.Текст =
				"ВЫБРАТЬ
				|	ЗаказНарядТовары.Ссылка
				|ИЗ
				|	Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
				|ГДЕ
				|	ЗаказНарядТовары.Партия = &Партия";

				ЗапросПоПартии.УстановитьПараметр("Партия", Стр.индкод);
				РезультатЗапроса = ЗапросПоПартии.Выполнить();
				Если НЕ РезультатЗапроса.Пустой() Тогда
					
					Выборка = РезультатЗапроса.Выбрать();
					Выборка.Следующий();
					ЗаказНарядОбъект = Выборка.Ссылка.ПолучитьОбъект();
					НайденнаяСтрока = ЗаказНарядОбъект.Товары.Найти(Стр.индкод, "Партия");
					
					Если НайденнаяСтрока <> Неопределено тогда 
						
						НайденнаяСтрока.Партия 		= Справочники.ИндКод.ПустаяСсылка(); 
						НайденнаяСтрока.Состояние		= Перечисления.СтатусыТовараВЗаказНаряде.Планово; // "Ожидание" для WT10 | "Планово" для приложение склад
						
						НайденнаяСтрока.Склад	 =	Справочники.Склады.ПустаяСсылка();   
						НайденнаяСтрока.Автомобиль = Справочники.Машины.ПустаяСсылка();
						
						ЗаказНарядОбъект.Записать(РежимЗаписиДокумента.Проведение); 
						Возврат;
					КонецЕсли;
				КонецЕсли; 
		КонецЕсли; 

	КонецЦикла;

// -- МазинЕС Если из ячейки РВР перенести деталь на ячейку НЕ РВР то деталь удалится из ЗакзНаряда

	Для Каждого Стр Из ЭтотОбъект Цикл
// При записи Регистра Сведений проверяется стеллаж, Если это ячейка РВР тогда в Заказ наряде в тч Товары меняется статус с "Планово" на "Собрано"
			Попытка
				Если СтрНайти(Строка(Стр.Стеллаж), "yachejka RVR") <> 0 ИЛИ СтрНайти(Строка(Стр.Стеллаж), "Сервисные услуги") <> 0 Тогда 
	// Сначала ищещем Заказ наряд по Партии в тч
					ЗапросПоПартии = Новый Запрос;
					ЗапросПоПартии.Текст =
					"ВЫБРАТЬ
					|	ЗаказНарядТовары.Ссылка
					|ИЗ
					|	Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
					|ГДЕ
					|	ЗаказНарядТовары.Партия = &Партия";
	
					ЗапросПоПартии.УстановитьПараметр("Партия", Стр.индкод);
	
				//@skip-check query-in-loop
					РезультатЗапроса = ЗапросПоПартии.Выполнить();
						
					Если РезультатЗапроса.Пустой() Тогда
	// Если не нашли по Партии, ищем по Номенклатуре
						ЗапросПоНоменклатуре = Новый Запрос;
						ЗапросПоНоменклатуре.Текст =
						"ВЫБРАТЬ
						|	ЗаказНарядТовары.Ссылка КАК Ссылка
						|ИЗ
						|	Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
						|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаряд КАК ЗаказНаряд
						|		ПО (ЗаказНарядТовары.Ссылка = ЗаказНаряд.Ссылка)
						|ГДЕ
						|	ЗаказНарядТовары.Номенклатура = &Номенклатура
						|	И ЗаказНаряд.ЯчейкаРВР = &ЯчейкаРВР";
	
						ЗапросПоНоменклатуре.УстановитьПараметр("Номенклатура", Стр.индкод.Владелец);
						ЗапросПоНоменклатуре.УстановитьПараметр("ЯчейкаРВР", Стр.Стеллаж);
						
						РезультатЗапроса = ЗапросПоНоменклатуре.Выполнить();
	
						Выборка = РезультатЗапроса.Выбрать();
	
						Пока	Выборка.Следующий() Цикл
									
									ЗаказНарядОбъект = Выборка.Ссылка.ПолучитьОбъект();
									//НайденнаяСтрока = ЗаказНарядОбъект.Товары.НайтиСтроки(Стр.индкод.Владелец, "Номенклатура");
																		
										Для Каждого Строка ИЗ   ЗаказНарядОбъект.Товары Цикл 
											
											Если  Строка.Номенклатура = Стр.индкод.Владелец Тогда
												  
												 Если Строка.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Планово
													Или Строка.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.ПустаяСсылка()
													или Строка.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Срочно
													или Строка.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Ожидание 
													или Строка.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Заказано Тогда   // "Ожидание" для WT10 | "Планово" для приложение склад
													// Меняем Статус в строке ТЧ На "Собрано" 
													Строка.Состояние		= Перечисления.СтатусыТовараВЗаказНаряде.Собрано;
													Строка.Партия			= Стр.индкод;
													Строка.Цена				= Стр.Цена; 
													Стуктура 				= ЗаполнитьАвтомобильНаСервере(Стр.индкод);
													Строка.Автомобиль		= Стуктура.Машина; 
													Строка.Склад			= Стуктура.Склад; 
													ЗаказНарядОбъект.Записать(РежимЗаписиДокумента.Проведение);
													Возврат;  
												 КонецЕсли; 
												  
											КонецЕсли;
											
										КонецЦикла; 
										
						КонецЦикла; 
									
					// Если нашли заказ по Партии в ТЧ, то дальше не ищем
					Иначе
	
						Выборка = РезультатЗапроса.Выбрать();
	
						Выборка.Следующий();
						ЗаказНарядОбъект = Выборка.Ссылка.ПолучитьОбъект();
						НайденнаяСтрока = ЗаказНарядОбъект.Товары.Найти(Стр.индкод, "Партия");
						Если НайденнаяСтрока <> Неопределено Тогда
							Если НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Планово
								Или НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.ПустаяСсылка() 
								или НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Срочно
								или НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Ожидание
								или Строка.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Заказано Тогда   // "Ожидание" для WT10 | "Планово" для приложение склад
	// Меняем Статус в строке ТЧ На "Собрано"
								НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Собрано;
								НайденнаяСтрока.Цена	=  Стр.Цена; 
								ЗаказНарядОбъект.Записать(РежимЗаписиДокумента.Проведение);
								Возврат;
							КонецЕсли;
	
						КонецЕсли;
					КонецЕсли;
					//Отказ = Истина;
				КонецЕсли;
			Исключение
				п = Истина;
			КонецПопытки;
		КонецЦикла;
/// Комлев 02/09/24 ---
КонецПроцедуры

Функция ЗаполнитьАвтомобильНаСервере(Партия)
	
	Структура = новый Структура();	
	
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РегистрНакопления1Остатки.машина КАК Машина,
	|	РегистрНакопления1Остатки.Склад КАК Склад
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1.Остатки(, индкод = &Партия) КАК РегистрНакопления1Остатки";
	Запрос.УстановитьПараметр("Партия",Партия);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Структура.Вставить("Машина",Выборка.Машина);
	Структура.Вставить("Склад",Выборка.Склад);
	Возврат Структура;
КонецФункции

