#!/bin/bash
# Rebuilds /etc/postfix/sasl_passwd with correct sender-dependent format.
# Runs after boky/postfix creates the default entry.
# Reads SENDER_n_FROM, SENDER_n_USER, SENDER_n_PASS (n=1..10)

SASL_FILE="/etc/postfix/sasl_passwd"

# Keep only the relay host line (default credentials), remove any sender lines
grep '^\[' "$SASL_FILE" > "${SASL_FILE}.tmp" 2>/dev/null
mv "${SASL_FILE}.tmp" "$SASL_FILE"

ADDED=0
for i in $(seq 1 10); do
    FROM_VAR="SENDER_${i}_FROM"
    USER_VAR="SENDER_${i}_USER"
    PASS_VAR="SENDER_${i}_PASS"

    FROM="${!FROM_VAR}"
    USER="${!USER_VAR}"
    PASS="${!PASS_VAR}"

    if [ -n "$FROM" ] && [ -n "$USER" ] && [ -n "$PASS" ]; then
        echo "$FROM $USER:$PASS" >> "$SASL_FILE"
        echo "init-sender-maps: added sender-dependent credentials for $FROM"
        ADDED=$((ADDED + 1))
    fi
done

postmap lmdb:"$SASL_FILE"
echo "init-sender-maps: postmap (lmdb) rebuilt with $ADDED sender(s)"
