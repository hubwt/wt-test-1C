
&НаКлиенте
Процедура ФиксМесРасходыПриИзменении(Элемент)
	РассчитатьСуммуРасходов();
КонецПроцедуры

&НаКлиенте
Процедура ПеременРасходыПриИзменении(Элемент)
	РассчитатьСуммуРасходов();
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммуРасходов()
	Объект.СуммаРасхода = Объект.ФиксМесРасходы.Итог("Сумма") + Объект.ПеременРасходы.Итог("Сумма");
КонецПроцедуры