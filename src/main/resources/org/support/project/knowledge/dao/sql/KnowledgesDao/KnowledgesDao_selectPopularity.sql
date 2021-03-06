SELECT
        KNOWLEDGES.*
        ,USERS.USER_NAME AS INSERT_USER_NAME
        ,UP_USER.USER_NAME AS UPDATE_USER_NAME
        ,COALESCE(SUM(POINT_KNOWLEDGE_HISTORIES.POINT), 0) AS POINT_ON_TERM
    FROM
        KNOWLEDGES
            LEFT OUTER JOIN POINT_KNOWLEDGE_HISTORIES
                ON (
                    KNOWLEDGES.KNOWLEDGE_ID = POINT_KNOWLEDGE_HISTORIES.KNOWLEDGE_ID
                    AND POINT_KNOWLEDGE_HISTORIES.INSERT_DATETIME BETWEEN ? AND ?
                )
            LEFT OUTER JOIN USERS
                ON USERS.USER_ID = KNOWLEDGES.INSERT_USER
            LEFT OUTER JOIN USERS AS UP_USER
                ON UP_USER.USER_ID = KNOWLEDGES.UPDATE_USER
    WHERE
        KNOWLEDGES.DELETE_FLAG = 0
    GROUP BY
        KNOWLEDGES.KNOWLEDGE_ID
        ,USERS.USER_NAME
        ,UP_USER.USER_NAME
    ORDER BY
        POINT_ON_TERM DESC
        ,KNOWLEDGES.POINT DESC
        ,KNOWLEDGES.UPDATE_DATETIME DESC 
    LIMIT ? OFFSET ?
