--マインドクラッシュ
function c15800838.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetTarget(c15800838.target)
	e1:SetOperation(c15800838.operation)
	c:RegisterEffect(e1)
end
function c15800838.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c15800838.filter(c,tc)
	return c:IsCode(tc) and c:IsFaceup()
end
function c15800838.operation(e,tp,eg,ep,ev,re,r,rp)
	local limit={
		[40044918 ]=true, --E·HERO エアーマン
		[37742478 ]=true, --オネスト
		[41470137 ]=true, --剣闘獣ベストロウリィ
		[26202165 ]=true, --クリッター
		[00423585 ]=true, --召喚僧サモンプリースト
		[33420078 ]=true, --ゾンビキャリア
		[65192027 ]=true, --ダーク·アームド·ドラゴン
		[15341821 ]=true, --ダンディライオン
		[98777036 ]=true, --トラゴエディア
		[16226786 ]=true, --深淵の暗殺者
		[80344569 ]=true, --N·グラン·モール
		[04906301 ]=true, --ネクロ·ガードナー
		[28297833 ]=true, --ネクロフェイス
		[52687916 ]=true, --氷結界の龍 トリシューラ
		[50321796 ]=true, --氷結界の龍 ブリューナク
		[33396948 ]=true, --封印されしエクゾディア
		[08124921 ]=true, --封印されし者の右足
		[70903634 ]=true, --封印されし者の右腕
		[44519536 ]=true, --封印されし者の左足
		[07902349 ]=true, --封印されし者の左腕
		[85215458 ]=true, --BF－月影のカルート
		[02009101 ]=true, --BF－疾風のゲイル
		[31305911 ]=true, --マシュマロン
		[44330098 ]=true, --冥府の使者ゴーズ
		[92826944 ]=true, --馬頭鬼
		[33508719 ]=true, --メタモルポット
		[96782886 ]=true, --メンタルマスター
		[95503687 ]=true, --ライトロード·サモナー ルミナス
		[48976825 ]=true, --異次元からの埋葬
		[66957584 ]=true, --インフェルニティガン
		[81439173 ]=true, --おろかな埋葬
		[67723438 ]=true, --緊急テレポート
		[91351370 ]=true, --黒い旋風
		[46052429 ]=true, --高等儀式術
		[83764718 ]=true, --死者蘇生
		[73915051 ]=true, --スケープ·ゴート
		[37520316 ]=true, --精神操作
		[32807846 ]=true, --増援
		[14087893 ]=true, --月の書
		[45809008 ]=true, --デステニー·ドロー
		[72892473 ]=true, --手札抹殺
		[42703248 ]=true, --ハリケーン
		[94886282 ]=true, --光の援軍
		[72302403 ]=true, --光の護封剣
		[53129443 ]=true, --ブラック·ホール
		[77565204 ]=true, --未来融合－フューチャー·フュージョン
		[58577036 ]=true, --名推理
		[43040603 ]=true, --モンスターゲート
		[01475311 ]=true, --闇の誘惑
		[23171610 ]=true, --リミッター解除
		[03136426 ]=true, --レベル制限B地区
		[27970830 ]=true, --六武の門
		[02295440 ]=true, --ワン·フォー·ワン
		[27174286 ]=true, --異次元からの帰還
		[93016201 ]=true, --王宮の弾圧
		[41420027 ]=true, --神の宣告
		[85742772 ]=true, --グラヴィティ・バインド－超重力の網－
		[53582587 ]=true, --激流葬
		[44095762 ]=true, --聖なるバリア－ミラーフォース－
		[64697231 ]=true, --ダスト·シュート
		[36468556 ]=true, --停戦協定
		[46652477 ]=true, --転生の予言
		[17078030 ]=true, --光の護封壁
		[15800838 ]=true, --マインドクラッシュ
		[32723153 ]=true, --マジカル·エクスプロージョン
		[97077563 ]=true  --リビングデッドの呼び声
	}
	local semi={
		[85087012 ]=true, --カードガンナー
		[57774843 ]=true, --裁きの龍
		[59509952 ]=true, --大天使クリスティア
		[23205979 ]=true, --魂を削る死霊
		[09411399 ]=true, --D－HERO ディアボリックガイ
		[14943837 ]=true, --デブリ·ドラゴン
		[48686504 ]=true, --ローンファイア·ブロッサム
		[72405967 ]=true, --王家の生け贄
		[03659803 ]=true, --オーバーロード・フュージョン
		[22046459 ]=true, --巨大化
		[05318639 ]=true, --サイクロン
		[91623717 ]=true, --連鎖爆撃
		[98494543 ]=true, --魔法石の採掘
		[29843091 ]=true, --おジャマトリオ
		[84749824 ]=true, --神の警告
		[53567095 ]=true, --ゴッドバードアタック
		[29401950 ]=true, --奈落の落とし穴
		[62279055 ]=true, --魔法の筒
		[80604091 ]=true  --血の代償
	}
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		local tc=g:GetFirst()
		local ct=0
		local og=Group.CreateGroup()
		local xg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_XYZ)
		if #xg>0 then 
			xg:ForEach(function(xc) og:Merge(xc:GetOverlayGroup()) end)
		end
		ct=ct+og:FilterCount(c15800838.filter,nil,tc:GetCode())
		ct=ct+Duel.GetMatchingGroupCount(c15800838.filter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,nil,tc:GetCode())
		if not (limit[tc:GetCode()] or (semi[tc:GetCode()] and ct>1) or ct>2) then
			Duel.ConfirmCards(tp,hg)
			Duel.ShuffleHand(1-tp)
		end
	else
		Duel.ConfirmCards(tp,hg)
		Duel.ShuffleHand(1-tp)
		local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local dg=sg:RandomSelect(tp,1)
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	end
end
