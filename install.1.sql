{{{ ACL

-- {{{ "acl_group"

CREATE TABLE "acl_group" (
  "id" SERIAL,
  "name" VARCHAR NOT NULL,
  "description" TEXT,
  "properties" TEXT,
  "mtime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "acl_group_name_key" UNIQUE("name"),
  CONSTRAINT "acl_group_pkey" PRIMARY KEY("id")
) WITH OIDS;

-- }}}
-- {{{ "acl_action"

CREATE TABLE "acl_action" (
  "id" SERIAL,
  "name" VARCHAR NOT NULL,
  "description" TEXT,
  "properties" TEXT,
  "mtime" TIMESTAMP(6) WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "acl_action_name_key" UNIQUE("name"),
  CONSTRAINT "acl_action_pkey" PRIMARY KEY("id")
) WITH OIDS;

-- }}}
-- {{{ "acl_user"

CREATE TABLE "acl_user" (
  "id" SERIAL,
  "login" VARCHAR NOT NULL,
  "email" VARCHAR NOT NULL,
  "password" VARCHAR NOT NULL,
  "first_name" VARCHAR,
  "last_name" VARCHAR,
  "properties" TEXT,
  "last_login" TIMESTAMP(0) WITHOUT TIME ZONE,
  "mtime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "acl_user_login_key" UNIQUE("login"),
  CONSTRAINT "acl_user_pkey" PRIMARY KEY("id")
) WITH OIDS;

-- }}}
-- {{{ "acl_action2group"

CREATE TABLE "acl_action2group" (
  "action_id" INTEGER NOT NULL,
  "group_id" INTEGER NOT NULL,
  CONSTRAINT "acl_group2action_pkey" PRIMARY KEY("action_id", "group_id"),
  CONSTRAINT "acl_group2action_fk" FOREIGN KEY ("group_id")
    REFERENCES "acl_group"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT "acl_group2action_fk1" FOREIGN KEY ("action_id")
    REFERENCES "acl_action"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITH OIDS;

-- }}}
CREATE INDEX "acl_action2group_idx" ON "acl_action2group" USING btree ("group_id");
-- {{{ "acl_user2group"

CREATE TABLE "acl_user2group" (
  "user_id" INTEGER NOT NULL,
  "group_id" INTEGER NOT NULL,
  CONSTRAINT "acl_user2group_pkey" PRIMARY KEY("user_id", "group_id"),
  CONSTRAINT "acl_user2group_fk" FOREIGN KEY ("user_id")
    REFERENCES "acl_user"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT "acl_user2group_fk1" FOREIGN KEY ("group_id")
    REFERENCES "acl_group"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITH OIDS;

-- }}}
CREATE INDEX "acl_user2group_idx" ON "acl_user2group" USING btree ("group_id");
-- {{{ "acl_log"

CREATE TABLE "acl_log" (
  "id" SERIAL,
  "user_id" INTEGER,
  "action_id" INTEGER NOT NULL,
  "action_name" VARCHAR NOT NULL,
  "is_eligible" SMALLINT NOT NULL,
  "data" TEXT,
  "ctime" TIMESTAMP(6) WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "acl_log_pkey" PRIMARY KEY("id")
) WITH OIDS;

-- }}}
CREATE INDEX "acl_log_idx" ON "acl_log" USING btree ("user_id");
CREATE INDEX "acl_log_idx1" ON "acl_log" USING btree ("action_id");
CREATE INDEX "acl_log_idx2" ON "acl_log" USING btree ("action_name");

-- {{{ uninstall

DROP TABLE IF EXISTS "acl_user2group";
DROP TABLE IF EXISTS "acl_action2group";
DROP TABLE IF EXISTS "acl_user";
DROP TABLE IF EXISTS "acl_group";
DROP TABLE IF EXISTS "acl_action";
DROP TABLE IF EXISTS "acl_log";

-- }}}

}}}
{{{ Message

-- {{{ "message"

CREATE TABLE "message" (
  "id" SERIAL,
  "type" INTEGER NOT NULL,
  "name" VARCHAR NOT NULL,
  "description" TEXT,
  "mtime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "message_pkey" PRIMARY KEY("id"),
  CONSTRAINT "message_type_fk" FOREIGN KEY ("type")
    REFERENCES "message_type"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITH OIDS;

-- }}}
-- {{{ "message_type"

CREATE TABLE "message_type" (
  "id" SERIAL,
  "name" VARCHAR NOT NULL,
  "description" TEXT,
  "mtime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "message_type_pkey" PRIMARY KEY("id")
) WITH OIDS;

-- }}}
-- {{{ "message_link"

CREATE TABLE "message_link" (
  "primary_id" INTEGER NOT NULL,
  "secondard_id" INTEGER NOT NULL,
  "link_type_id" INTEGER NOT NULL,
  CONSTRAINT "message_links_pkey" PRIMARY KEY("primary_id", "secondard_id"),
  CONSTRAINT "message_links_primary_id_fk" FOREIGN KEY ("primary_id")
    REFERENCES "message"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT "message_links_secondary_id_fk" FOREIGN KEY ("secondard_id")
    REFERENCES "message"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITH OIDS;

-- }}}
-- {{{ "message_link_type"

CREATE TABLE "message_link_type" (
  "id" SERIAL,
  "name" VARCHAR NOT NULL,
  "description" TEXT,
  "mtime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "message_link_type_pkey" PRIMARY KEY("id")
) WITH OIDS;

-- }}}

}}}
{{{ EAV

{{{ CREATE OR REPLACE FUNCTION "eavTrigInsertDeleteEntity2Value" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigInsertDeleteEntity2Value" () RETURNS trigger AS
$body$
DECLARE
	subj				record;
	parent				record;
	isVariationGroup	boolean;
BEGIN

	IF TG_OP = 'INSERT' THEN

		subj := NEW;

		-- maintain entity2attribute view
		BEGIN
			INSERT INTO eav_entity2attribute (entity_id, attribute_id, entity_guid_id, entity_guid_type)
			VALUES (NEW.entity_id, NEW.attribute_id, NEW.entity_guid_id, NEW.entity_guid_type);
		EXCEPTION WHEN unique_violation THEN
		END;

	ELSE

		subj := OLD;

		-- maintain entity2attribute view
		DELETE FROM eav_entity2attribute
		WHERE
			entity_id = OLD.entity_id
		and attribute_id not in (
			SELECT
				e2v.attribute_id
			FROM
				eav_entity2value e2v
			WHERE
				e2v.entity_id = OLD.entity_id
			and e2v.value_id <> OLD.value_id
		);

	END IF;

	-- if it's a regular product or product group (bundle or variation group)
	IF subj.entity_guid_type=1 or subj.entity_guid_type=2 THEN

		-- check if it is a variation group
		SELECT EXISTS (SELECT id FROM product WHERE id=subj.entity_guid_id and subtype=3) INTO isVariationGroup;

		-- if it isn't a variation group
		IF NOT isVariationGroup THEN

			-- if it's a regular product
			IF subj.entity_guid_type=1 THEN

				-- get all variation groups containing this product
				FOR parent IN
					SELECT DISTINCT
						p.id	as guidId,
						2		as guidType
					FROM
						product sm
					INNER JOIN product p ON (p.id = sm.parent_id)
					WHERE
						sm.symlink_target_id = subj.entity_guid_id
					and p.subtype = 3
				LOOP
					-- update values of the variation group
					PERFORM "eavFuncSetVariationGroupValues"(parent.guidId, parent.guidType);
				END LOOP;

			END IF;

			-- update entity2value_group relation
			PERFORM "eavFuncRefreshEntity2ValueGroup"(subj.entity_id);

		END IF;

	END IF;


	RETURN subj;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavFuncSetVariationGroupValues" (integer, integer) RETURNS "pg_catalog"."void" AS

CREATE OR REPLACE FUNCTION "eavFuncSetVariationGroupValues" (integer, integer) RETURNS "pg_catalog"."void" AS
$body$
DECLARE
	guidId			ALIAS FOR $1;
	guidType		ALIAS FOR $2;
	entityId		integer;
BEGIN

	SELECT "eavFuncEntityId"(guidId, guidType) INTO entityId;

	-- delete the values that no longer apply
	DELETE FROM eav_entity2value
	WHERE
		entity_id = entityId
	and value_id not in (
		SELECT
			e2v.value_id
		FROM
			eav_entity2value e2v
		INNER JOIN product p ON (p.id = e2v.entity_guid_id)
		INNER JOIN product sm ON (sm.symlink_target_id = p.id)
		WHERE
			e2v.entity_guid_type in (1,2)
		and	p.status in (1,2)
		and sm.parent_id = guidId
	);

	-- add the values that were not there yet
	INSERT INTO eav_entity2value(entity_id, value_id, entity_guid_id, entity_guid_type, attribute_id)
	SELECT DISTINCT
		entityId,
		e2v.value_id,
		guidId,
		guidType,
		e2v.attribute_id
	FROM
		eav_entity2value e2v
	INNER JOIN product p ON (p.id = e2v.entity_guid_id)
	INNER JOIN product sm ON (sm.symlink_target_id = p.id)
	WHERE
		e2v.entity_guid_type in (1,2)
	and	p.status in (1,2)
	and sm.parent_id = guidId
	and e2v.value_id not in (
		SELECT
			value_id
		FROM
			eav_entity2value
		WHERE
			entity_id = entityId
	);

END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavFuncBundleCommonValues" (INTEGER, INTEGER, VARCHAR) RETURNS "pg_catalog"."void" AS

CREATE OR REPLACE FUNCTION "eavFuncBundleCommonValues" (INTEGER, INTEGER, VARCHAR) RETURNS "pg_catalog"."void" AS
$body$
DECLARE
	guidId				ALIAS FOR $1;
	guidType			ALIAS FOR $2;
	attrGroup			ALIAS FOR $3;
	entityId			integer;
	memberEntityId		integer;
	parent              record;
BEGIN

	SELECT "eavFuncEntityId"(guidId, guidType) INTO entityId;

	-- Remove non-common compatibility EAV values
	FOR parent IN
		SELECT DISTINCT
			pm.id	as memberGuidId,
			pm.type	as memberGuidType
		FROM product sm
		INNER JOIN product pm ON (pm.id = sm.symlink_target_id)
		WHERE TRUE
		AND	sm.parent_id = guidId
	LOOP

		-- remove the compatibility value that not exists in members
		DELETE FROM eav_entity2value
		WHERE TRUE
		AND entity_id = entityId
		AND value_id IN (

			SELECT DISTINCT e2v.value_id
			FROM eav_entity2value e2v
			JOIN eav_attribute2group a2g ON (a2g.attribute_id = e2v.attribute_id)
			JOIN eav_attribute_group ag ON (ag.id = a2g.group_id)
			WHERE TRUE
			AND e2v.entity_guid_id = guidId
			AND e2v.entity_guid_type = guidType
			AND ag.name = attrGroup
			AND e2v.value_id NOT IN (

				SELECT DISTINCT e2v2.value_id
				FROM eav_entity2value e2v2
				JOIN eav_attribute2group a2g2 ON (a2g2.attribute_id = e2v2.attribute_id)
				JOIN eav_attribute_group ag2 ON (ag2.id = a2g2.group_id)
				WHERE TRUE
				AND e2v2.entity_guid_id = parent.memberGuidId
				AND e2v2.entity_guid_type = parent.memberGuidType
				AND ag2.name = attrGroup

			)
		)
		;

	END LOOP;

END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;

}}}
{{{ CREATE OR REPLACE FUNCTION "eavFuncSetBundleValues" (integer, integer) RETURNS "pg_catalog"."void" AS

CREATE OR REPLACE FUNCTION "eavFuncSetBundleValues" (integer, integer) RETURNS "pg_catalog"."void" AS
$body$
DECLARE
	guidId			ALIAS FOR $1;
	guidType		ALIAS FOR $2;
	entityId		integer;
BEGIN

	SELECT "eavFuncEntityId"(guidId, guidType) INTO entityId;

	-- delete the values that no longer apply
	DELETE FROM eav_entity2value
	WHERE
		entity_id = entityId
	and value_id not in (
		SELECT
			e2v.value_id
		FROM
			eav_entity2value e2v
		INNER JOIN product p ON (p.id = e2v.entity_guid_id)
		INNER JOIN product sm ON (sm.symlink_target_id = p.id)
		WHERE
			e2v.entity_guid_type in (1,2)
		and	p.status in (1,2)
		and sm.parent_id = guidId
	)
	AND value_id not in (

		SELECT DISTINCT v.id
		FROM eav_value v
		JOIN eav_attribute a ON (v.attribute_id = a.id)
		WHERE TRUE
		AND (a.name = 'promotion' OR a.name = 'package_type')

	)
	;

	-- add the values that were not there yet
	INSERT INTO eav_entity2value(entity_id, value_id, entity_guid_id, entity_guid_type, attribute_id)
	SELECT DISTINCT
		entityId,
		e2v.value_id,
		guidId,
		guidType,
		e2v.attribute_id
	FROM
		eav_entity2value e2v
	INNER JOIN product p ON (p.id = e2v.entity_guid_id)
	INNER JOIN product sm ON (sm.symlink_target_id = p.id)
	WHERE
		e2v.entity_guid_type in (1,2)
	and	p.status in (1,2)
	and sm.parent_id = guidId
	and e2v.value_id not in (
		SELECT
			value_id
		FROM
			eav_entity2value
		WHERE
			entity_id = entityId
	);

	-- Remove non-common compatibility EAV values
	PERFORM "eavFuncBundleCommonValues"(guidId, guidType, 'compatibility');

END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavFuncRefreshEntity2ValueGroup" (integer) RETURNS "pg_catalog"."void" AS

CREATE OR REPLACE FUNCTION "eavFuncRefreshEntity2ValueGroup" (integer) RETURNS "pg_catalog"."void" AS
$body$
DECLARE
	entityId							ALIAS FOR $1;
	entity								record;
	entityHasStrictCompatibility		boolean;
	valueGroupHasStrictCompatibility	boolean;
	entityMatchStrictAttributes			boolean;
	matchCondition						boolean;
	valueGroup							record;
	strictValue							record;
	parent								record;
	strictAttributeGroupId				integer;
BEGIN

	SELECT e.guid_id, e.guid_type INTO entity FROM eav_entity e WHERE e.id = entityId;

	IF NOT FOUND THEN
		RETURN;
	END IF;

    IF entity.guid_type<>1 and entity.guid_type<>2 THEN
    	RETURN;
    END IF;

	-- clear existing E2VGs
	DELETE FROM eav_entity2value_group e2vg WHERE e2vg.entity_id = entityId;

	SELECT id INTO strictAttributeGroupId FROM eav_attribute_group WHERE name='strict_compatibility';

	IF NOT FOUND THEN
		RETURN;
	END IF;

	-- check if the product has strict compatibility attribute
	SELECT EXISTS (
		SELECT
			1
		FROM
			eav_attribute2group a2g
		WHERE
			a2g.group_id = strictAttributeGroupId
		and	exists (
			SELECT
				1
			FROM
				eav_entity2attribute e2a
			WHERE
				e2a.entity_id = entityId
			and	e2a.attribute_id = a2g.attribute_id
			LIMIT 1
		)
		LIMIT 1
	)
	INTO entityHasStrictCompatibility;

	-- If the product does not have strict compatibility attributes
	IF NOT entityHasStrictCompatibility THEN

		-- Assign all value groups with matched value sets
		INSERT INTO eav_entity2value_group (entity_id, group_id, entity_guid_id, entity_guid_type)
		SELECT DISTINCT
			entityId,
			vg.id,
			entity.guid_id,
			entity.guid_type
		FROM
			eav_value_group vg
		INNER JOIN eav_value2group v2g ON (v2g.group_id = vg.id)
		INNER JOIN eav_entity2value e2v ON (e2v.value_id = v2g.value_id)
		WHERE
			e2v.entity_id = entityId

		-- all group values must match the product values
		and not exists (
			SELECT
				1
			FROM
				eav_value2group	v2g
			LEFT JOIN eav_entity2value e2v ON (e2v.value_id = v2g.value_id and e2v.entity_id = entityId)
			WHERE
				v2g.group_id = vg.id
            and e2v.entity_guid_id is null
			LIMIT 1
		);

	-- if the product has strict compatibility attributes
	ELSE

		INSERT INTO eav_entity2value_group (entity_id, group_id, entity_guid_id, entity_guid_type)
		SELECT DISTINCT
			entityId,
			vg.id,
			entity.guid_id,
			entity.guid_type
		FROM
			eav_value_group vg
		INNER JOIN eav_value2group v2g ON (v2g.group_id = vg.id)
		INNER JOIN eav_entity2value e2v ON (e2v.value_id = v2g.value_id)
		WHERE
			e2v.entity_id = entityId

		-- all group values must match the product values
		and not exists (
			SELECT
				1
			FROM
				eav_value2group	v2g
			LEFT JOIN eav_entity2value e2v ON (e2v.value_id = v2g.value_id and e2v.entity_id = entityId)
			WHERE
				v2g.group_id = vg.id
			and e2v.entity_guid_id is null
			LIMIT 1
		)

		and
		(
			vg.type <> 'compatibility'
			or
			(
				vg.type = 'compatibility'

				-- Strict attribute from EAV value group should all exist in strict attributes of product
				and not exists(
					SELECT
						1
					FROM
						eav_entity2value e2v
					INNER JOIN eav_attribute2group a2g   ON (a2g.attribute_id = e2v.attribute_id)
					LEFT JOIN eav_value2group v2g ON (e2v.attribute_id = v2g.attribute_id AND v2g.group_id = vg.id)
					WHERE
						e2v.entity_id = entityId
					and a2g.group_id = strictAttributeGroupId
					and v2g.attribute_id is null
					LIMIT 1
				)
			)
		)
	;

	END IF;

	-- Here a small optimization hack:
	-- We assume that we never update "eav_entity2value_group" relation (E2VG) manually and only via "eav_entity2value" relation
	-- In this case we do not need to execute trigger (actually the function eavTrigInsertDeleteEntity2ValueGroup)
	-- on every INSERT or UPDATE of E2VG relation

	-- Otherwise if we decide that we do not such optimization please do the following:
	-- 1) enable trigger "eav_entity2value_group_ins_del_tr"
	-- 2) comment the code below wrapped with "*" sign:

	-- ****************************************************************

	-- if it's a regular product
    IF entity.guid_type=1 THEN

		-- get all variation groups containing this product
		FOR parent IN
			SELECT DISTINCT
				p.id	as guidId,
				2		as guidType
			FROM
				product sm
			INNER JOIN product p ON (p.id = sm.parent_id)
			WHERE
				sm.symlink_target_id = entity.guid_id
			and p.subtype = 3
		LOOP
			-- update EAV value groups of the variation group
			PERFORM "eavFuncSetVariationGroupValueGroups"(parent.guidId, parent.guidType);
		END LOOP;

	END IF;

	-- ****************************************************************

END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


-- this function (trigger) is not used but needed if we decide to enable "eav_entity2value_group_ins_del_tr" trigger
-- see at the bottom of "eavFuncRefreshEntity2ValueGroup" function for details
}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigInsertDeleteEntity2ValueGroup" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigInsertDeleteEntity2ValueGroup" () RETURNS trigger AS
$body$
DECLARE
	subj		record;
	parent		record;
BEGIN

	-- this function (trigger) is not used but needed if we decide to enable "eav_entity2value_group_ins_del_tr" trigger
	-- see at the bottom of "eavFuncRefreshEntity2ValueGroup" function for details

	IF TG_OP = 'INSERT' THEN
		subj := NEW;
	ELSE
		subj := OLD;
	END IF;

	-- if it's a regular product
	IF subj.entity_guid_type=1 THEN

		-- get all variation groups containing this product
		FOR parent IN
			SELECT DISTINCT
				p.id	as guidId,
				2		as guidType
			FROM
				product sm
			INNER JOIN product p ON (p.id = sm.parent_id)
			WHERE
				sm.symlink_target_id = subj.entity_guid_id
			and p.subtype = 3
		LOOP
			-- update value groups of the variation group
			PERFORM "eavFuncSetVariationGroupValueGroups"(parent.guidId, parent.guidType);
		END LOOP;

	END IF;

	RETURN subj;

END;
$body$
LANGUAGE 'plpgsql' STABLE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavFuncSetVariationGroupValueGroups" (integer, integer) RETURNS "pg_catalog"."void" AS

CREATE OR REPLACE FUNCTION "eavFuncSetVariationGroupValueGroups" (integer, integer) RETURNS "pg_catalog"."void" AS
$body$
DECLARE
	guidId		ALIAS FOR $1;
	guidType	ALIAS FOR $2;
	entityId	integer;
BEGIN

	SELECT "eavFuncEntityId"(guidId, guidType) INTO entityId;

	-- delete the VGs that no longer apply
	DELETE FROM eav_entity2value_group WHERE entity_id = entityId;

	-- add the VGs that were not there yet
	INSERT INTO eav_entity2value_group(entity_id, group_id, entity_guid_id, entity_guid_type)
	SELECT DISTINCT
		entityId,
		e2vg.group_id,
		guidId,
		guidType
	FROM
		eav_entity2value_group e2vg
	INNER JOIN product p ON (p.id = e2vg.entity_guid_id )
	INNER JOIN product sm ON (sm.symlink_target_id = p.id)
	WHERE
		e2vg.entity_guid_type in (1,2)
	and	p.status in (1,2)
	and sm.parent_id = guidId
	and e2vg.group_id not in (
		SELECT
			group_id
		FROM
			eav_entity2value_group
		WHERE
			entity_id = entityId
	);
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavFuncRefreshVariationGroup" (integer, integer) RETURNS "pg_catalog"."void" AS

CREATE OR REPLACE FUNCTION "eavFuncRefreshVariationGroup" (integer, integer) RETURNS "pg_catalog"."void" AS
$body$
DECLARE
    guidId      ALIAS FOR $1;
    guidType    ALIAS FOR $2;
BEGIN
    -- update variation AV and AVG
    PERFORM "eavFuncSetVariationGroupValues"(guidId, guidType);
    PERFORM "eavFuncSetVariationGroupValueGroups"(guidId, guidType);
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;




-- :TODO: perform all these actions via some queue and PHP crontab based script
}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigInsertDeleteValue2Group" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigInsertDeleteValue2Group" () RETURNS trigger AS
$body$
DECLARE
	row		record;
	subj	record;
BEGIN

	IF TG_OP = 'INSERT' THEN
		subj := NEW;
	ELSE
		subj := OLD;
	END IF;

	FOR row IN
		SELECT
			e2v.entity_id
		FROM
			eav_entity2value e2v
		WHERE (
			e2v.value_id = subj.value_id
		OR	e2v.value_id IN (
				SELECT
					v2g.value_id
				FROM
					eav_value2group v2g
				WHERE
					v2g.group_id = subj.group_id
			)
		)
		AND e2v.entity_guid_type in (1,2)

	LOOP
		PERFORM "eavFuncRefreshEntity2ValueGroup"(row.entity_id);
	END LOOP;

	RETURN subj;

END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;

}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateAttribute" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateAttribute" () RETURNS trigger AS
$body$
BEGIN
    IF NEW.id<>OLD.id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Attribute id modification is prohibited (old.id = %, new.id = %)', OLD.id, NEW.id;
    END IF;

    RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;

}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateAttribute2Group" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateAttribute2Group" () RETURNS trigger AS
$body$
BEGIN
    IF NEW.attribute_id<>OLD.attribute_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV attribute2group relation. Use delete/insert instead (old.attribute_id = %, new.attribute_id = %)', OLD.attribute_id, NEW.attribute_id;
    END IF;

    IF NEW.group_id<>OLD.group_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV attribute2group relation. Use delete/insert instead (old.group_id = %, new.group_id = %)', OLD.group_id, NEW.group_id;
    END IF;

    RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;

}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateAttributeGroup" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateAttributeGroup" () RETURNS trigger AS
$body$
BEGIN
    IF NEW.id<>OLD.id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Attribute group id modification is prohibited (old.id = %, new.id = %)', OLD.id, NEW.id;
    END IF;
	RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateEntity" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateEntity" () RETURNS trigger AS
$body$
BEGIN

	IF NEW.guid_id<>OLD.guid_id THEN
    	UPDATE eav_entity2value SET entity_guid_id = NEW.guid_id WHERE entity_id = NEW.id;
    	UPDATE eav_entity2value_group SET entity_guid_id = NEW.guid_id WHERE entity_id = NEW.id;
    	UPDATE eav_entity2attribute_group SET entity_guid_id = NEW.guid_id WHERE entity_id = NEW.id;
    	UPDATE eav_entity2attribute SET entity_guid_id = NEW.guid_id WHERE entity_id = NEW.id;
    END IF;

	IF NEW.guid_type<>OLD.guid_type THEN
    	UPDATE eav_entity2value SET entity_guid_type = NEW.guid_type WHERE entity_id = NEW.id;
    	UPDATE eav_entity2value_group SET entity_guid_type = NEW.guid_type WHERE entity_id = NEW.id;
    	UPDATE eav_entity2attribute_group SET entity_guid_type = NEW.guid_type WHERE entity_id = NEW.id;
    	UPDATE eav_entity2attribute SET entity_guid_type = NEW.guid_type WHERE entity_id = NEW.id;
    END IF;

    IF NEW.id<>OLD.id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Entity id modification is prohibited (old.id = %, new.id = %)', OLD.id, NEW.id;
    END IF;

    RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateEntity2Attribute" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateEntity2Attribute" () RETURNS trigger AS
$body$
BEGIN
    IF NEW.attribute_id<>OLD.attribute_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV entity2attribute relation. Use delete/insert instead (old.attribute_id = %, new.attribute_id = %)', OLD.attribute_id, NEW.attribute_id;
    END IF;

    IF NEW.entity_id<>OLD.entity_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV entity2attribute relation. Use delete/insert instead (old.entity_id = %, new.entity_id = %)', OLD.entity_id, NEW.entity_id;
    END IF;
	RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateEntity2AttributeGroup" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateEntity2AttributeGroup" () RETURNS trigger AS
$body$
BEGIN
    IF NEW.entity_id<>OLD.entity_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV entity2attribute_group relation. Use delete/insert instead. (old.entity_id = %, new.entity_id = %)', OLD.entity_id, NEW.entity_id;
    END IF;

    IF NEW.group_id<>OLD.group_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV entity2attribute_group relation. Use delete/insert instead. (old.group_id = %, new.group_id = %)', OLD.group_id, NEW.group_id;
    END IF;
	RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateEntity2Value" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateEntity2Value" () RETURNS trigger AS
$body$
BEGIN
    IF NEW.entity_id<>OLD.entity_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV entity2value relation. Use delete/insert instead. (old.entity_id = %, new.entity_id = %)', OLD.entity_id, NEW.entity_id;
    END IF;

    IF NEW.value_id<>OLD.value_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV entity2value relation. Use delete/insert instead. (old.value_id = %, new.value_id = %)', OLD.value_id, NEW.value_id;
    END IF;

    IF NEW.attribute_id<>OLD.attribute_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV entity2value relation. (old.attribute_id = %, new.attribute_id = %)', OLD.attribute_id, NEW.attribute_id;
    END IF;

	RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateEntity2ValueGroup" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateEntity2ValueGroup" () RETURNS trigger AS
$body$
BEGIN
    IF NEW.entity_id<>OLD.entity_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV entity2value_group relation. Use delete/insert instead. (old.entity_id = %, new.entity_id = %)', OLD.entity_id, NEW.entity_id;
    END IF;

    IF NEW.group_id<>OLD.group_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV entity2value_group relation. Use delete/insert instead. (old.group_id = %, new.group_id = %)', OLD.group_id, NEW.group_id;
    END IF;
	RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateValue" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateValue" () RETURNS trigger AS
$body$
BEGIN
    IF NEW.id<>OLD.id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Value id modification is prohibited (old.id = %, new.id = %)', OLD.id, NEW.id;
    END IF;

    IF NEW.attribute_id<>OLD.attribute_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update value attribute_id. Use insert/delete instead. (old.attribute_id = %, new.attribute_id = %)', OLD.attribute_id, NEW.attribute_id;
    END IF;

	RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateValue2Group" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateValue2Group" () RETURNS trigger AS
$body$
BEGIN
    IF NEW.value_id<>OLD.value_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV value2group relation. Use delete/insert instead. (old.value_id = %, new.value_id = %)', OLD.value_id, NEW.value_id;
    END IF;

    IF NEW.group_id<>OLD.group_id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Do not update EAV value2group relation. Use delete/insert instead (old.group_id = %, new.group_id = %)', OLD.group_id, NEW.group_id;
    END IF;
	RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavTrigUpdateValueGroup" () RETURNS trigger AS

CREATE OR REPLACE FUNCTION "eavTrigUpdateValueGroup" () RETURNS trigger AS
$body$
BEGIN
    IF NEW.id<>OLD.id THEN
		RAISE EXCEPTION 'UPDATE TRIGGER: Value group id modification is prohibited (old.id = %, new.id = %)', OLD.id, NEW.id;
    END IF;
	RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;


}}}
{{{ CREATE OR REPLACE FUNCTION "eavFuncEntityId" (integer, integer) RETURNS integer AS

CREATE OR REPLACE FUNCTION "eavFuncEntityId" (integer, integer) RETURNS integer AS
$body$
DECLARE
	guidId		ALIAS FOR $1;
	guidType	ALIAS FOR $2;
	entity		record;
BEGIN
	SELECT id INTO entity FROM eav_entity WHERE guid_id = guidId and guid_type = guidType;
	IF NOT FOUND THEN
		BEGIN
			INSERT INTO eav_entity (guid_id, guid_type) VALUES (guidId, guidType);
		EXCEPTION WHEN unique_violation THEN
		END;
		SELECT id INTO entity FROM eav_entity WHERE guid_id = guidId and guid_type = guidType;
	END IF;
	RETURN entity.id;
END;
$body$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;





}}}
{{{ CREATE TABLE "eav_attribute" (

CREATE TABLE "eav_attribute" (
  "id" SERIAL,
  "old_id" INTEGER,
  "name" VARCHAR(50) NOT NULL,
  "title" VARCHAR(255),
  "description" TEXT,
  "properties" TEXT,
  "mtime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "eav_attribute_pkey" PRIMARY KEY("id")
) WITHOUT OIDS;

}}}
{{{ CREATE UNIQUE INDEX "eav_attribute_idx" ON "eav_attribute"

CREATE UNIQUE INDEX "eav_attribute_idx" ON "eav_attribute"
  USING btree ("name");

}}}
{{{ CREATE INDEX "eav_attribute_idx_old_id" ON "eav_attribute"

CREATE INDEX "eav_attribute_idx_old_id" ON "eav_attribute"
  USING btree ("old_id");

}}}
{{{ CREATE TRIGGER "eav_attribute_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_attribute_upd_tr" BEFORE UPDATE
ON "eav_attribute" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateAttribute"();

}}}
{{{ CREATE TABLE "eav_attribute_group" (

CREATE TABLE "eav_attribute_group" (
  "id" SERIAL,
  "old_id" INTEGER,
  "name" VARCHAR(50) NOT NULL,
  "properties" TEXT,
  "mtime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "eav_attribute_group_pkey" PRIMARY KEY("id")
) WITHOUT OIDS;

}}}
{{{ CREATE UNIQUE INDEX "eav_attribute_group_idx" ON "eav_attribute_group"

CREATE UNIQUE INDEX "eav_attribute_group_idx" ON "eav_attribute_group"
  USING btree ("name");

}}}
{{{ CREATE INDEX "eav_attribute_group_idx_old_id" ON "eav_attribute_group"

CREATE INDEX "eav_attribute_group_idx_old_id" ON "eav_attribute_group"
  USING btree ("old_id");

}}}
{{{ CREATE TRIGGER "eav_attribute_group_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_attribute_group_upd_tr" BEFORE UPDATE
ON "eav_attribute_group" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateAttributeGroup"();

}}}
{{{ CREATE TABLE "eav_attribute2group" (

CREATE TABLE "eav_attribute2group" (
  "attribute_id" INTEGER NOT NULL,
  "group_id" INTEGER NOT NULL,
  "sort" INTEGER,
  CONSTRAINT "eav_attribute2group_pkey" PRIMARY KEY("attribute_id", "group_id"),
  CONSTRAINT "eav_attribute2group_fk" FOREIGN KEY ("attribute_id")
    REFERENCES "eav_attribute"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT "eav_attribute2group_fk1" FOREIGN KEY ("group_id")
    REFERENCES "eav_attribute_group"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITHOUT OIDS;

}}}
{{{ CREATE INDEX "eav_attribute2group_idx" ON "eav_attribute2group"

CREATE INDEX "eav_attribute2group_idx" ON "eav_attribute2group"
  USING btree ("attribute_id");

}}}
{{{ CREATE INDEX "eav_attribute2group_idx1" ON "eav_attribute2group"

CREATE INDEX "eav_attribute2group_idx1" ON "eav_attribute2group"
  USING btree ("group_id");

}}}
{{{ CREATE TRIGGER "eav_attribute2group_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_attribute2group_upd_tr" BEFORE UPDATE
ON "eav_attribute2group" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateAttribute2Group"();

}}}
{{{ CREATE TABLE "eav_value" (

CREATE TABLE "eav_value" (
  "id" SERIAL,
  "old_id" INTEGER,
  "attribute_id" INTEGER NOT NULL,
  "name" VARCHAR NOT NULL,
  "body" TEXT,
  "description" TEXT,
  "sort" VARCHAR(100),
  "properties" TEXT,
  "mtime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "eav_value_pkey" PRIMARY KEY("id"),
  CONSTRAINT "eav_value_fk" FOREIGN KEY ("attribute_id")
    REFERENCES "eav_attribute"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITHOUT OIDS;

}}}
{{{ CREATE INDEX "eav_value_idx" ON "eav_value"

CREATE INDEX "eav_value_idx" ON "eav_value"
  USING btree ("attribute_id");

}}}
{{{ CREATE UNIQUE INDEX "eav_value_idx_old_id" ON "eav_value"

CREATE UNIQUE INDEX "eav_value_idx_old_id" ON "eav_value"
  USING btree ("old_id");

}}}
{{{ CREATE UNIQUE INDEX "eav_value_uix" ON "eav_value"

CREATE UNIQUE INDEX "eav_value_uix" ON "eav_value"
  USING btree ("attribute_id", "body");

}}}
{{{ CREATE TRIGGER "eav_value_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_value_upd_tr" BEFORE UPDATE
ON "eav_value" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateValue"();

}}}
{{{ CREATE TABLE "eav_value_group" (

CREATE TABLE "eav_value_group" (
  "id" SERIAL,
  "old_id" INTEGER,
  "type" VARCHAR(25) NOT NULL,
  "description" TEXT,
  "properties" TEXT,
  "mtime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "eav_value_group_pkey" PRIMARY KEY("id")
) WITHOUT OIDS;

}}}
{{{ CREATE INDEX "eav_value_group_idx" ON "eav_value_group"

CREATE INDEX "eav_value_group_idx" ON "eav_value_group"
  USING btree ("type");

}}}
{{{ CREATE UNIQUE INDEX "eav_value_group_idx_old_id" ON "eav_value_group"

CREATE UNIQUE INDEX "eav_value_group_idx_old_id" ON "eav_value_group"
  USING btree ("old_id");

}}}
{{{ CREATE TRIGGER "eav_value_group_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_value_group_upd_tr" BEFORE UPDATE
ON "eav_value_group" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateValueGroup"();

}}}
{{{ CREATE TABLE "eav_value2group" (

CREATE TABLE "eav_value2group" (
  "value_id" INTEGER NOT NULL,
  "group_id" INTEGER NOT NULL,
  "attribute_id" INTEGER NOT NULL,
  CONSTRAINT "eav_value2group_pkey" PRIMARY KEY("value_id", "group_id"),
  CONSTRAINT "eav_value2group_fk" FOREIGN KEY ("value_id")
    REFERENCES "eav_value"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT "eav_value2group_fk1" FOREIGN KEY ("group_id")
    REFERENCES "eav_value_group"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITHOUT OIDS;

}}}
{{{ CREATE INDEX "eav_value2group_idx" ON "eav_value2group"

CREATE INDEX "eav_value2group_idx" ON "eav_value2group"
  USING btree ("value_id");

}}}
{{{ CREATE INDEX "eav_value2group_idx2" ON "eav_value2group"

CREATE INDEX "eav_value2group_idx2" ON "eav_value2group"
  USING btree ("attribute_id");

}}}
{{{ CREATE TRIGGER "eav_value2group_ins_del_tr" AFTER INSERT OR DELETE

CREATE TRIGGER "eav_value2group_ins_del_tr" AFTER INSERT OR DELETE
ON "eav_value2group" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigInsertDeleteValue2Group"();

}}}
{{{ CREATE TRIGGER "eav_value2group_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_value2group_upd_tr" BEFORE UPDATE
ON "eav_value2group" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateValue2Group"();


}}}
{{{ CREATE TABLE "eav_value2value" (

CREATE TABLE "eav_value2value" (
  "parent_id" INTEGER NOT NULL,
  "child_id" INTEGER NOT NULL,
  CONSTRAINT "eav_value2value_pkey" PRIMARY KEY("parent_id", "child_id"),
  CONSTRAINT "eav_value2value_fk" FOREIGN KEY ("parent_id")
    REFERENCES "eav_value"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT "eav_value2value_fk1" FOREIGN KEY ("child_id")
    REFERENCES "eav_value"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITH OIDS;


}}}
{{{ CREATE TABLE "eav_entity" (

CREATE TABLE "eav_entity" (
  "id" SERIAL,
  "guid_id" INTEGER NOT NULL,
  "guid_type" INTEGER NOT NULL,
  "properties" TEXT,
  "mtime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  "ctime" TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT "eav_entity_pkey" PRIMARY KEY("id")
) WITHOUT OIDS;

}}}
{{{ CREATE UNIQUE INDEX "eav_entity_idx" ON "eav_entity"

CREATE UNIQUE INDEX "eav_entity_idx" ON "eav_entity"
  USING btree ("guid_id", "guid_type");

}}}
{{{ CREATE TRIGGER "eav_entity_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_entity_upd_tr" BEFORE UPDATE
ON "eav_entity" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateEntity"();

}}}
{{{ CREATE TABLE "eav_entity2attribute" (

CREATE TABLE "eav_entity2attribute" (
  "entity_id" INTEGER NOT NULL,
  "attribute_id" INTEGER NOT NULL,
  "entity_guid_id" INTEGER NOT NULL,
  "entity_guid_type" INTEGER NOT NULL,
  CONSTRAINT "eav_entity2attribute_pkey" PRIMARY KEY("entity_id", "attribute_id"),
  CONSTRAINT "eav_entity2attribute_fk" FOREIGN KEY ("entity_id")
    REFERENCES "eav_entity"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT "eav_entity2attribute_fk1" FOREIGN KEY ("attribute_id")
    REFERENCES "eav_attribute"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITHOUT OIDS;

}}}
{{{ CREATE INDEX "eav_entity2attribute_idx" ON "eav_entity2attribute"

CREATE INDEX "eav_entity2attribute_idx" ON "eav_entity2attribute"
  USING btree ("entity_guid_id", "entity_guid_type");

}}}
{{{ CREATE INDEX "eav_entity2attribute_idx1" ON "eav_entity2attribute"

CREATE INDEX "eav_entity2attribute_idx1" ON "eav_entity2attribute"
  USING btree ("entity_id");

}}}
{{{ CREATE TRIGGER "eav_entity2attribute_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_entity2attribute_upd_tr" BEFORE UPDATE
ON "eav_entity2attribute" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateEntity2Attribute"();

}}}
{{{ CREATE TABLE "eav_entity2attribute_group" (

CREATE TABLE "eav_entity2attribute_group" (
  "entity_id" INTEGER NOT NULL,
  "group_id" INTEGER NOT NULL,
  "entity_guid_id" INTEGER NOT NULL,
  "entity_guid_type" INTEGER NOT NULL,
  CONSTRAINT "eav_entity2attribute_group_pkey" PRIMARY KEY("entity_id", "group_id"),
  CONSTRAINT "eav_entity2attribute_group_fk" FOREIGN KEY ("entity_id")
    REFERENCES "eav_entity"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT "eav_entity2attribute_group_fk1" FOREIGN KEY ("group_id")
    REFERENCES "eav_attribute_group"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITHOUT OIDS;

}}}
{{{ CREATE INDEX "eav_entity2attribute_group_idx" ON "eav_entity2attribute_group"

CREATE INDEX "eav_entity2attribute_group_idx" ON "eav_entity2attribute_group"
  USING btree ("entity_guid_id", "entity_guid_type");

}}}
{{{ CREATE INDEX "eav_entity2attribute_group_idx1" ON "eav_entity2attribute_group"

CREATE INDEX "eav_entity2attribute_group_idx1" ON "eav_entity2attribute_group"
  USING btree ("entity_id");

}}}
{{{ CREATE TRIGGER "eav_entity2attribute_group_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_entity2attribute_group_upd_tr" BEFORE UPDATE
ON "eav_entity2attribute_group" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateEntity2AttributeGroup"();

}}}
{{{ CREATE TABLE "eav_entity2value" (

CREATE TABLE "eav_entity2value" (
  "entity_id" INTEGER NOT NULL,
  "value_id" INTEGER NOT NULL,
  "entity_guid_id" INTEGER NOT NULL,
  "entity_guid_type" INTEGER NOT NULL,
  "attribute_id" INTEGER NOT NULL,
  CONSTRAINT "eav_entity2value_idx" PRIMARY KEY("entity_id", "value_id"),
  CONSTRAINT "eav_entity2value_fk" FOREIGN KEY ("attribute_id")
    REFERENCES "eav_attribute"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT "eav_value2entity_fk" FOREIGN KEY ("value_id")
    REFERENCES "eav_value"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT "eav_value2entity_fk2" FOREIGN KEY ("entity_id")
    REFERENCES "eav_entity"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITHOUT OIDS;

}}}
{{{ CREATE INDEX "eav_entity2value_idx1" ON "eav_entity2value"

CREATE INDEX "eav_entity2value_idx1" ON "eav_entity2value"
  USING btree ("value_id");

}}}
{{{ CREATE INDEX "eav_entity2value_idx2" ON "eav_entity2value"

CREATE INDEX "eav_entity2value_idx2" ON "eav_entity2value"
  USING btree ("entity_guid_id", "entity_guid_type");

}}}
{{{ CREATE INDEX "eav_entity2value_idx3" ON "eav_entity2value"

CREATE INDEX "eav_entity2value_idx3" ON "eav_entity2value"
  USING btree ("attribute_id");

}}}
{{{ CREATE INDEX "eav_entity2value_idx4" ON "eav_entity2value"

CREATE INDEX "eav_entity2value_idx4" ON "eav_entity2value"
  USING btree ("entity_id");

}}}
{{{ CREATE TRIGGER "eav_entity2value_ins_del_tr" AFTER INSERT OR DELETE

CREATE TRIGGER "eav_entity2value_ins_del_tr" AFTER INSERT OR DELETE
ON "eav_entity2value" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigInsertDeleteEntity2Value"();

}}}
{{{ CREATE TRIGGER "eav_entity2value_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_entity2value_upd_tr" BEFORE UPDATE
ON "eav_entity2value" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateEntity2Value"();

}}}
{{{ CREATE TABLE "eav_entity2value_group" (

CREATE TABLE "eav_entity2value_group" (
  "entity_id" INTEGER NOT NULL,
  "group_id" INTEGER NOT NULL,
  "entity_guid_id" INTEGER NOT NULL,
  "entity_guid_type" INTEGER NOT NULL,
  "rank" SMALLINT,
  CONSTRAINT "eav_entity2value_group_pkey" PRIMARY KEY("entity_id", "group_id"),
  CONSTRAINT "eav_entity2value_group_fk" FOREIGN KEY ("entity_id")
    REFERENCES "eav_entity"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT "eav_entity2value_group_fk1" FOREIGN KEY ("group_id")
    REFERENCES "eav_value_group"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITHOUT OIDS;

}}}
{{{ CREATE INDEX "eav_entity2value_group_idx" ON "eav_entity2value_group"

CREATE INDEX "eav_entity2value_group_idx" ON "eav_entity2value_group"
  USING btree ("entity_guid_id", "entity_guid_type");

}}}
{{{ CREATE INDEX "eav_entity2value_group_idx1" ON "eav_entity2value_group"

CREATE INDEX "eav_entity2value_group_idx1" ON "eav_entity2value_group"
  USING btree ("entity_id");

}}}
{{{ CREATE INDEX "eav_entity2value_group_idx2" ON "eav_entity2value_group"

CREATE INDEX "eav_entity2value_group_idx2" ON "eav_entity2value_group"
  USING btree ("group_id");

-- this trigger should be disabled
-- see at the bottom of "eavFuncRefreshEntity2ValueGroup" function for details
}}}
{{{ CREATE TRIGGER "eav_entity2value_group_ins_del_tr" AFTER INSERT OR DELETE

CREATE TRIGGER "eav_entity2value_group_ins_del_tr" AFTER INSERT OR DELETE
ON "eav_entity2value_group" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigInsertDeleteEntity2ValueGroup"();

-- optimization hack
-- see at the bottom of "eavFuncRefreshEntity2ValueGroup" function for details
ALTER TABLE "eav_entity2value_group" DISABLE TRIGGER "eav_entity2value_group_ins_del_tr";

}}}
{{{ CREATE TRIGGER "eav_entity2value_group_upd_tr" BEFORE UPDATE

CREATE TRIGGER "eav_entity2value_group_upd_tr" BEFORE UPDATE
ON "eav_entity2value_group" FOR EACH ROW
EXECUTE PROCEDURE "eavTrigUpdateEntity2ValueGroup"();


}}}

}}}


