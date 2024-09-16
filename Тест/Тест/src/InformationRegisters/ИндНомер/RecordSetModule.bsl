Процедура ПередЗаписью(Отказ, Замещение)
/// Комлев 02/09/24 +++

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Для Каждого Стр Из ЭтотОбъект Цикл
// При записи Регистра Сведений проверяется стеллаж, Если это ячейка РВР тогда в Заказ наряде в тч Товары меняется статус с "Планово" на "Собрано"
		Попытка
			Если СтрНайти(Строка(Стр.Стеллаж), "yachejka RVR") <> 0 Тогда 
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
					|	ЗаказНарядТовары.Ссылка
					|ИЗ
					|	Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
					|ГДЕ
					|	ЗаказНарядТовары.Номенклатура = &Номенклатура";

					ЗапросПоНоменклатуре.УстановитьПараметр("Номенклатура", Стр.индкод.Владелец);

					РезультатЗапроса = ЗапросПоНоменклатуре.Выполнить();

					Выборка = РезультатЗапроса.Выбрать();

					Выборка.Следующий();
					ЗаказНарядОбъект = Выборка.Ссылка.ПолучитьОбъект();
					НайденнаяСтрока = ЗаказНарядОбъект.Товары.Найти(Стр.индкод.Владелец, "Номенклатура");
					Если НайденнаяСтрока <> Неопределено Тогда
						Если НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Планово
							Или НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.ПустаяСсылка() Тогда
// Меняем Статус в строке ТЧ На "Собрано"
							НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Собрано;
							ЗаказНарядОбъект.Записать();
						КонецЕсли;
					КонецЕсли;
				
// Если нашли заказ по Партии в ТЧ, то дальше не ищем
				Иначе

					Выборка = РезультатЗапроса.Выбрать();

					Выборка.Следующий();
					ЗаказНарядОбъект = Выборка.Ссылка.ПолучитьОбъект();
					НайденнаяСтрока = ЗаказНарядОбъект.Товары.Найти(Стр.индкод, "Партия");
					Если НайденнаяСтрока <> Неопределено Тогда
						Если НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Планово
							Или НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.ПустаяСсылка() Тогда
// Меняем Статус в строке ТЧ На "Собрано"
							НайденнаяСтрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Собрано;
							ЗаказНарядОбъект.Записать();
						КонецЕсли;

					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Исключение
			п = Истина;
		КонецПопытки;
	КонецЦикла;
/// Комлев 02/09/24 ---
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

КонецПроцедуры