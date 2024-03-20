with
cte_1 as
(select * from facebook_ads_basic_daily
join facebook_adset on facebook_ads_basic_daily.adset_id = facebook_adset.adset_id
join facebook_campaign on facebook_ads_basic_daily.campaign_id = facebook_campaign.campaign_id),
cte_2 as
(select
ad_date,
'facebook ads' as media_source,
campaign_name,
adset_name,
spend,
impressions,
reach,
clicks,
leads,
"value"
from cte_1
union all
select
ad_date,
'goodle ads' as media_source,
campaign_name,
adset_name,
spend,
impressions,
reach,
clicks,
leads,
"value"
from google_ads_basic_daily)
select
ad_date,
media_source,
campaign_name,
adset_name,
sum(spend) as "spend_result",
sum(impressions) as "impressions_result",
sum(reach) as "reach_result",
sum(clicks) as "clicks_result",
sum(leads) as "leads_result",
sum("value") as "value_result"
from cte_2
where spend > 0
group by
ad_date,
media_source,
campaign_name,
adset_name;

with cte_1 as
(select * from facebook_ads_basic_daily
join facebook_adset on facebook_ads_basic_daily.adset_id = facebook_adset.adset_id
join facebook_campaign on facebook_ads_basic_daily.campaign_id = facebook_campaign.campaign_id),
cte_2 as
(select
ad_date,
'facebook ads' as media_source,
campaign_name,
adset_name,
spend,
impressions,
reach,
clicks,
leads,
"value"
from cte_1
union all
select
ad_date,
'goodle ads' as media_source,
campaign_name,
adset_name,
spend,
impressions,
reach,
clicks,
leads,
"value"
from google_ads_basic_daily)
select
adset_name,
sum(spend) as "spend_result",
sum(impressions) as "impressions_result",
sum(reach) as "reach_result",
sum(clicks) as "clicks_result",
sum(leads) as "leads_result",
sum("value") as "value_result",
round((((sum("value")-sum(spend))/sum(spend)::numeric)*100), 2) as romi
from cte_2
where spend > 0
group by adset_name
having sum(spend) > 500000
order by romi desc
limit 1;